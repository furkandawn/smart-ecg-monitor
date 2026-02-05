import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../../features/emergency/emergency_settings_controller.dart';
import '../../features/emergency/emergency_contacts_controller.dart';

import '../widgets/contact_card.dart';
import '../actions/contact_add_action.dart';
import '../widgets/confirm_dialog.dart';

class EmergencyContactsScreen extends ConsumerWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    
    final contacts = ref.watch(emergencyContactsProvider);
    final settings = ref.watch(emergencySettingsProvider);
    final settingsCtl = ref.read(emergencySettingsProvider.notifier);
    final contactsCtl = ref.read(emergencyContactsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.tr('emergency_contacts')),
      ),
      body: Column(
        children: [
          // 1. Contacts List
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, i) {
                final c = contacts[i];
                final isPrimaryCall = settings.primaryCallContactId == c.id;

                return ContactCard(
                  name: c.name,
                  phone: c.phone,
                  isPrimary: isPrimaryCall,
                  onPrimaryChanged: (val) {
                    settingsCtl.setPrimaryCallContact(val ? c.id : null);
                  },
                  onDelete: () async {
                    // Confirm Delete Logic
                    final confirm = await _showDeleteConfirmation(context, i18n, c.name);
                    if (confirm) {
                      contactsCtl.remove(c.id);
                      if (isPrimaryCall) {
                        settingsCtl.setPrimaryCallContact(null);
                      }
                    }
                  },
                );
              },
            ),
          ),

          // 2. Info Footer
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              i18n.tr('sms_info_text'),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddContactAction(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, I18n i18n, String name) async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: i18n.tr('delete_contact'),
      content: '${i18n.tr('delete_confirm_start')} "$name" ${i18n.tr('delete_confirm_end')}',
      confirmText: i18n.tr('delete'),
      cancelText: i18n.tr('cancel'),
      isDestructive: true,
      );
      return confirmed;
  }
}