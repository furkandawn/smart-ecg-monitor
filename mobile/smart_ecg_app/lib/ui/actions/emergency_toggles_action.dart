import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';
import '../../features/emergency/emergency_settings_controller.dart';

class EmergencyTogglesAction extends ConsumerWidget {
  const EmergencyTogglesAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final settings = ref.watch(emergencySettingsProvider);
    final settingsCtl = ref.read(emergencySettingsProvider.notifier);

    return Column(
      children: [
        SwitchListTile(
          title: Text(i18n.tr('auto_sms_label')),
          value: settings.autoSmsEnabled,
          onChanged: settingsCtl.setAutoSms,
        ),
        SwitchListTile(
          title: Text(i18n.tr('auto_call_label')),
          value: settings.autoCallEnabled,
          onChanged: settingsCtl.setAutoCall,
        ),
        SwitchListTile(
          title: Text(i18n.tr('include_location_label')),
          value: settings.includeLocationInSms,
          onChanged: settingsCtl.setIncludeLocation,
        ),
      ],
    );
  }
}