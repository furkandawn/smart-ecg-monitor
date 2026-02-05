import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ble_state.dart';
import 'ble_config.dart';
import 'ble_models.dart';
import 'ble_saved_device.dart';

final bleControllerProvider = AsyncNotifierProvider<BleController, BleState>(BleController.new);

class BleController extends AsyncNotifier<BleState> {
  BluetoothDevice? _device;

  BluetoothCharacteristic? _liveChar;
  BluetoothCharacteristic? _ctrlChar;
  BluetoothCharacteristic? _eventChar;

  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<List<int>>? _liveSub;
  StreamSubscription<List<int>>? _ctrlSub;
  StreamSubscription<List<int>>? _eventSub;

  final _emergencyCtrl = StreamController<BleEmergencyPacket>.broadcast();
  Stream<BleEmergencyPacket> get emergencyPackets => _emergencyCtrl.stream;

  final _ecgSamplesCtrl = StreamController<int>.broadcast();
  Stream<int> get ecgSamples => _ecgSamplesCtrl.stream;

  final List<int> _incomingHistory = [];
  bool _isReceivingHistory = false;

  @override
  Future<BleState> build() async {
    ref.onDispose(() {
      _resetConnection();
      _emergencyCtrl.close();
      _ecgSamplesCtrl.close();
    });
    return const BleIdle();
  }

  /* ───────────── Scan ───────────── */

  Future<void> startScan() async {
    state = const AsyncValue.data(BleScanning());
    try {
      await FlutterBluePlus.stopScan();
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      state = AsyncValue.data(BleError(e.toString()));
    }
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  /* ───────────── Connect (Standard) ───────────── */

  Future<void> connect(ScanResult result, {bool autoConnect = false}) async {
    try {
      state = const AsyncValue.data(BleConnecting());
      await FlutterBluePlus.stopScan();

      final device = result.device;

      // 1. Connect
      await device.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );

      // 2. Save Preference
      await BleStorage.saveDevice(
        device.remoteId.str,
        device.platformName.isNotEmpty ? device.platformName : "Unknown Device",
        auto : autoConnect,
      );

      // 3. Setup Services & Listeners (Shared Logic)
      await _setupConnection(device);

      state = AsyncValue.data(BleConnected(device));
    } catch (e) {
      debugPrint("CONNECTION FAILED: $e");
      _resetConnection();
      state = AsyncValue.data(BleError(e.toString()));
    }
  }

  /* ───────────── Reconnect (Direct ID) ───────────── */
  
  Future<void> reconnect(String deviceId) async {
    try {
      state = const AsyncValue.data(BleConnecting());
      
      // 1. Create instance from ID (No scanning needed)
      final device = BluetoothDevice.fromId(deviceId);
      
      // 2. Connect
      await device.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );

      // 3. Setup Services & Listeners (Shared Logic)
      await _setupConnection(device);

      state = AsyncValue.data(BleConnected(device));
    } catch (e) {
      debugPrint("RECONNECT FAILED: $e");
      // Optional: Clear storage if reconnect fails repeatedly?
      // await BleStorage.clear(); 
      state = AsyncValue.data(BleError(e.toString()));
    }
  }

  /* ───────────── Disconnect ───────────── */

  Future<void> disconnect() async {
    try {
      await stopEcgStream();
      await _device?.disconnect();
    } catch (e) {
      debugPrint("DISCONNECTION FAILED: $e");
    }

    _resetConnection();
    state = const AsyncValue.data(BleIdle());
  }

  /* ───────────── LIVE ECG (UPDATED) ───────────── */

  Future<void> startEcgStream() async {
    if (_liveChar == null || _ctrlChar == null) {
      debugPrint("❌ Characteristics not ready");
      return;
    }

    debugPrint("▶️  Starting ECG stream...");

    // 1. Subscribe to LIVE characteristic (data stream)
    await _liveChar!.setNotifyValue(true);
    await _liveSub?.cancel();

    // 2. Parse ALL samples from each packet (20 samples × 2 bytes = 40 bytes)
    _liveSub = _liveChar!.onValueReceived.listen((bytes) {
      // Parse all int16 samples (little-endian)
      for (int i = 0; i < bytes.length; i += 2) {
        if (i + 1 < bytes.length) {
          // Read 2 bytes as int16 little-endian
          int low = bytes[i];
          int high = bytes[i + 1];
          
          // Combine to signed int16
          int value = (high << 8) | low;
          
          // Convert to signed (handle negative values)
          if (value > 32767) {
            value = value - 65536;
          }
          
          _ecgSamplesCtrl.add(value);
        }
      }
    });

    // 3. Send START command to CTRL characteristic ✅
    try {
      await _ctrlChar!.write(
        Uint8List.fromList([cmdStartLive]),  // 0x11
        withoutResponse: false,
      );
      debugPrint("✅ START command sent to CTRL (0x11)");
    } catch (e) {
      debugPrint("❌ Failed to send START command: $e");
    }

    // 4. Update state
    final current = state.value;
    if (current is BleConnected) {
      state = AsyncValue.data(
        BleStreaming(current.device, bpm: current.bpm, signalLoss: current.signalLoss),
      );
    }
  }

  Future<void> stopEcgStream() async {
    debugPrint("⏸️  Stopping ECG stream...");

    // 1. Send STOP command to CTRL characteristic ✅
    if (_ctrlChar != null) {
      try {
        await _ctrlChar!.write(
          Uint8List.fromList([cmdStopLive]),  // 0x12
          withoutResponse: false,
        );
        debugPrint("✅ STOP command sent to CTRL (0x12)");
      } catch (e) {
        debugPrint("❌ Failed to send STOP command: $e");
      }
    }

    // 2. Unsubscribe from LIVE notifications
    await _liveSub?.cancel();
    _liveSub = null;
    
    try {
      await _liveChar?.setNotifyValue(false); 
    } catch (e) {
      debugPrint("⚠️  Error disabling notifications: $e");
    }

    // 3. Update state
    final current = state.value;
    if (current is BleStreaming) {
      state = AsyncValue.data(
        BleConnected(current.device, bpm: current.bpm, signalLoss: current.signalLoss),
      );
    }
  }

  /* ───────────── HELPERS ───────────── */
  
  void _onCtrlPacket(List<int> p) {
    if (p.isEmpty) return;
    final current = state.value;
    if (current == null || (current is! BleConnected && current is! BleStreaming)) return;

    switch (p[0]) {
      case packetBpm:
        if (p.length >= 3) {
          final bpm = p[1] | (p[2] << 8);
          _updateState(current: current, bpm: bpm);
          debugPrint("📉 UPDATE BPM: $bpm at ${DateTime.now()}");
        }
        break;
      case packetLoss:
        if (p.length >= 2) {
          _updateState(current: current, signalLoss: p[1] == 2);
          debugPrint("💾 SAVING EVENT at ${DateTime.now()} with BPM: ${current.bpm}");
        }
        break;
    }
  }

  void _onEventPacket(List<int> p) {
    if (p.isEmpty) return;
    if (p[0] == packetHeader) {
      if (p.length > 1 && p[1] == eventStart) {
        _isReceivingHistory = true;
        _incomingHistory.clear();
      } else if (p.length > 1 && p[1] == eventEnd) {
        _isReceivingHistory = false;
        final current = state.value;
        debugPrint("EVENT END PACKET: $p");
        debugPrint("💾 SAVING TO DB -> BPM: ${current?.bpm} (Snapshot Size: ${_incomingHistory.length})");

        _emergencyCtrl.add(BleEmergencyPacket(
          bpm: current?.bpm,
          snapshot: Uint8List.fromList(_incomingHistory),
        ));
      }
    } else if (p[0] == packetData && _isReceivingHistory) {
      _incomingHistory.addAll(p.sublist(1));
    }
  }

  void _updateState({required BleState current, int? bpm, bool? signalLoss}) {
    final device = (current is BleConnected) ? current.device 
                 : (current is BleStreaming) ? current.device 
                 : null;

    if (device == null) return;

    final nextBpm = bpm ?? current.bpm;
    final nextLoss = signalLoss ?? current.signalLoss;
    
    state = AsyncValue.data(
      current is BleStreaming
          ? BleStreaming(device, bpm: nextBpm, signalLoss: nextLoss)
          : BleConnected(device, bpm: nextBpm, signalLoss: nextLoss),
    );
  }

  Future<void> _setupConnection(BluetoothDevice device) async {
    _device = device;

    if (Platform.isAndroid) {
      await device.requestConnectionPriority(connectionPriorityRequest: ConnectionPriority.high);
    }

    await _connectionSub?.cancel();
    _connectionSub = device.connectionState.listen((s) {
      if (s == BluetoothConnectionState.disconnected) {
        debugPrint("Device disconnected unexpectedly.");
        disconnect();
      }
    });

    final services = await device.discoverServices();

    _liveChar = _findCharacteristic(services, liveCharUuid);
    _ctrlChar = _findCharacteristic(services, ctrlCharUuid);
    _eventChar = _findCharacteristic(services, eventCharUuid);

    if (_liveChar == null) throw Exception('LIVE ECG characteristic not found');
    if (_ctrlChar == null) throw Exception('CTRL characteristic not found');
    if (_eventChar == null) throw Exception('EVENT characteristic not found');

    await _ctrlChar!.setNotifyValue(true);
    await _ctrlSub?.cancel();
    _ctrlSub = _ctrlChar!.onValueReceived.listen(_onCtrlPacket);

    await _eventChar!.setNotifyValue(true);
    await _eventSub?.cancel();
    _eventSub = _eventChar!.onValueReceived.listen(_onEventPacket);
  }

  void _resetConnection() {
    _liveSub?.cancel();
    _ctrlSub?.cancel();
    _eventSub?.cancel();
    _connectionSub?.cancel();
    _liveSub = null;
    _ctrlSub = null;
    _eventSub = null;
    _connectionSub = null;
    _incomingHistory.clear();
    _isReceivingHistory = false;
    _device = null;
    _liveChar = null;
    _ctrlChar = null;
    _eventChar = null;
  }

  BluetoothCharacteristic? _findCharacteristic(List<BluetoothService> services, String charUuid) {
    for (final s in services) {
      if (s.uuid.toString().toLowerCase() == serviceUuid.toLowerCase()) {
        for (final c in s.characteristics) {
          if (c.uuid.toString().toLowerCase() == charUuid.toLowerCase()) {
            return c;
          }
        }
      }
    }
    return null;
  }
}