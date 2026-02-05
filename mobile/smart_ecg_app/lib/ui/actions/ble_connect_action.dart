import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../features/ble/ble_controller.dart';
import 'bluetooth_scan_sheet.dart';
import '../widgets/bluetooth_off_dialog.dart';

class BleConnectAction {
  static Future<void> execute(
    BuildContext context,
    WidgetRef ref,
    bool isConnected,
  ) async {
    final bleCtl = ref.read(bleControllerProvider.notifier);

    if (isConnected) {
      await bleCtl.disconnect();
      return;
    }

    final adapterState = await FlutterBluePlus.adapterState.first;

    if (adapterState == BluetoothAdapterState.off) {
      if (context.mounted) {
        BluetoothOffDialog.show(context);
      }
      return;
    }

    await bleCtl.startScan();

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const DeviceScanSheet(),
      );
    }
  }
}
