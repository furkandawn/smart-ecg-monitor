import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class BleState {
  final int? bpm;
  final bool signalLoss;

  const BleState({
    this.bpm,
    this.signalLoss = false,
  });
}

class BleIdle extends BleState { const BleIdle(); }
class BleScanning extends BleState { const BleScanning(); }
class BleConnecting extends BleState { const BleConnecting(); }

class BleConnected extends BleState {
  final BluetoothDevice device;
  const BleConnected(this.device, {super.bpm, super.signalLoss = false});
}

class BleStreaming extends BleConnected {
  const BleStreaming(super.device, {super.bpm, super.signalLoss = false});
}

class BleError extends BleState {
  final String message;
  const BleError(this.message);
}