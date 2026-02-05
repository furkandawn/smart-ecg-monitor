import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../actions/ble_connect_action.dart';

class ConnectButton extends ConsumerWidget {
  final bool isConnected;

  const ConnectButton({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isConnected ? Colors.red.shade50 : Colors.blue.shade50,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isConnected ? Colors.red : Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(isConnected ? Icons.link_off : Icons.bluetooth),
          label: Text(
            isConnected ? i18n.tr('disconnect') : i18n.tr('connect_to_device'),
            style: const TextStyle(fontSize: 18),
          ),
          onPressed: () => BleConnectAction.execute(context, ref, isConnected),
        ),
      ),
    );
  }
}