import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';

class BluetoothOffDialog extends ConsumerWidget {
  const BluetoothOffDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const BluetoothOffDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    return AlertDialog(
      title: Text(i18n.tr('bluetooth_off_title')),
      content: Text(i18n.tr('bluetooth_off_content')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(i18n.tr('ok')),
        ),
      ],
    );
  }
}