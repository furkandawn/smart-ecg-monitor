import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import 'ble_state.dart';

extension BleStateUI on BleState {
  
  Color get color {
    return switch (this) {
      BleStreaming()  => Colors.green,
      BleConnected()  => Colors.green,
      BleConnecting() => Colors.blue,
      BleScanning()   => Colors.purpleAccent,
      BleError()      => Colors.red,
      _               => Colors.grey,
    };
  }

  String label(WidgetRef ref) {
    final i18n = I18n.of(ref.context, ref);

    return switch (this) {
      BleStreaming(:final device) => '${i18n.tr('streaming_prefix')}${device.platformName}',
      BleConnected(:final device) => '${i18n.tr('connected_prefix')}${device.platformName}',
      BleConnecting() =>                i18n.tr('connecting_status'),
      BleScanning()   =>                i18n.tr('scanning_status'),
      BleError(:final message) =>     '${i18n.tr('error_prefix')}$message',
      _ =>                              i18n.tr('not_connected_status'),
    };
  }

  IconData get icon {
    return switch (this) {
      BleStreaming()  =>              Icons.monitor_heart,
      BleConnected()  =>              Icons.bluetooth_connected,
      BleConnecting() =>              Icons.bluetooth_searching,
      BleScanning()   =>              Icons.bluetooth_searching,
      BleError()      =>              Icons.bluetooth_disabled,
      _               =>              Icons.bluetooth_disabled,
    };
  }
  
  bool get isConnected => this is BleConnected || this is BleStreaming;
}