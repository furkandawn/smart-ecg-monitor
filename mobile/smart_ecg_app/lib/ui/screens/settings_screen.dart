import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../../features/emergency/emergency_countdown_controller.dart';
import '../../features/emergency/emergency_contacts_controller.dart';

// Import your new widgets
import '../actions/language_button_action.dart';
import '../actions/emergency_toggles_action.dart';
import '../actions/emergency_message_tile.dart';
import '../widgets/test_emergency_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final countdown = ref.read(emergencyCountdownProvider.notifier);
    final contacts = ref.watch(emergencyContactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.tr('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Language
          const LanguageSelectorTile(),

          const Divider(height: 32),

          // 2. Emergency Settings (Toggles)
          const EmergencyTogglesAction(),

          const Divider(height: 32),

          // 3. Edit Message
          const EmergencyMessageTile(),

          const Divider(height: 32),

          // 4. Test Button
          TestEmergencyButton(
            isEnabled: contacts.isNotEmpty,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(i18n.tr('test_emergency_triggered_snack')),
                ),
              );
              countdown.start(10);
            },
          ),

          const Divider(height: 32),

          // 5. Footer Info
          const SizedBox(height: 16),
          Text(
            i18n.tr('sms_info_text'),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}