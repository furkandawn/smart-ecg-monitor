import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../../features/emergency/emergency_settings_controller.dart';
import '../widgets/text_input_dialog.dart';

class EmergencyMessageTile extends ConsumerWidget {
  const EmergencyMessageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final settings = ref.watch(emergencySettingsProvider);
    final settingsCtl = ref.read(emergencySettingsProvider.notifier);

    return ListTile(
      title: Text(i18n.tr('emergency_message_title')),
      subtitle: Text(i18n.tr('emergency_message_subtitle')),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final result = await TextInputDialog.show(
          context,
          title: i18n.tr('change_emergency_sms_title'),
          initialValue: settings.smsTemplate,
          confirmText: i18n.tr('done'),
          cancelText: i18n.tr('cancel'),
          maxLines: 4,
        );

        if (result != null) {
          settingsCtl.setTemplate(result);
        }
      },
    );
  }
}