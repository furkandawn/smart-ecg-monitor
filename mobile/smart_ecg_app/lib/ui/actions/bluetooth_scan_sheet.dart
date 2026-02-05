import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ble/ble_controller.dart';
import '../../core/localization/i18n.dart';
import '../widgets/confirm_dialog.dart';

class DeviceScanSheet extends ConsumerWidget {
  const DeviceScanSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleCtl = ref.read(bleControllerProvider.notifier);
    final i18n = I18n.of(context, ref);

    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              i18n.tr('scanning_status'), 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: bleCtl.scanResults,
              builder: (context, snapshot) {
                final results = snapshot.data ?? const [];
                
                if (results.isEmpty) {
                  return Center(child: Text(i18n.tr('no_devices_found')));
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, i) {
                    final selectedResult = results[i];
                    return ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(_deviceName(selectedResult.device)),
                      subtitle: Text('${i18n.tr('rssi_prefix')}${selectedResult.rssi}'),
                      onTap: () async {
                        final bool confirmed = await ConfirmDialog.show(
                          context,
                          title: i18n.tr('auto_connect_confirm_title'),
                          content: '${i18n.tr('auto_connect_confirm_body')}\n${_deviceName(selectedResult.device)}',
                          confirmText: i18n.tr('yes'),
                          cancelText: i18n.tr('no'),
                        );
                        await bleCtl.connect(selectedResult, autoConnect: confirmed);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _deviceName(BluetoothDevice device) {
    final name = device.platformName;
    return name.isEmpty ? device.remoteId.toString() : name;
  }
}