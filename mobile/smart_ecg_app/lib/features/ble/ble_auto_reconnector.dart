import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';

import 'ble_controller.dart';
import 'ble_state.dart';
import 'ble_saved_device.dart';

// 1. The Provider definition
final bleAutoReconnectProvider = Provider<BleAutoReconnector>((ref) {
  ref.keepAlive();
  final reconnector = BleAutoReconnector(ref);
  
  ref.onDispose(() {
    reconnector.dispose();
  });

  return reconnector;
});

class BleAutoReconnector {
  final Ref ref;
  StreamSubscription? _adapterSub;
  Timer? _monitorTimer;

  BleAutoReconnector(this.ref) {
    _init();
  }

  void _init() {
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        _attemptReconnectLogic();
      }
    });
    _monitorTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _attemptReconnectLogic();
    });

    // Initial attempt on startup
    _attemptReconnectLogic();
  }

  Future<void> _attemptReconnectLogic() async {
    final savedDevice = await BleStorage.getLastDevice();

    if (savedDevice == null || !savedDevice.autoConnect) return;

    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) return;

    final bleState = ref.read(bleControllerProvider).value;
    if (bleState is BleConnected || bleState is BleStreaming || bleState is BleConnecting) {
      return;
    }
    
    debugPrint("🔄 Auto-reconnector: Attempting to reconnect to ${savedDevice.name}");
    await ref.read(bleControllerProvider.notifier).reconnect(savedDevice.id);
  }

  void dispose() {
    _adapterSub?.cancel();
    _monitorTimer?.cancel();
  }
}