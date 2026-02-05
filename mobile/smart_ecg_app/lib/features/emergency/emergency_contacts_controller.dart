import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'emergency_contacts_repository.dart';
import 'emergency_settings_controller.dart';
import '../../data/database/app_database.dart';

final emergencyContactsProvider =
    NotifierProvider<EmergencyContactsController, List<EmergencyContact>>(
        EmergencyContactsController.new);

class EmergencyContactsController
    extends Notifier<List<EmergencyContact>> {

  @override
  List<EmergencyContact> build() {
    final repo = ref.read(emergencyContactsRepositoryProvider);

    final sub = repo.watchContacts().listen((rows) {
      state = rows;
    });

    ref.onDispose(sub.cancel);
    return const [];
  }

  Future<void> add(String name, String phone) async {
    final repo = ref.read(emergencyContactsRepositoryProvider);
    final int newId = await repo.addContact(name: name, phone: phone);

    // Domain rule: first contact becomes primary
    ref.read(emergencySettingsProvider.notifier)
        .setPrimaryCallContact(newId);
  }

  Future<void> remove(int id) async {
    final repo = ref.read(emergencyContactsRepositoryProvider);
    await repo.deleteContact(id);

    final settings = ref.read(emergencySettingsProvider);

    // Domain rule: ensure valid primary contact
    if (settings.primaryCallContactId == id) {
      final remaining = state.where((c) => c.id != id).toList();

      ref.read(emergencySettingsProvider.notifier).setPrimaryCallContact(
        remaining.isNotEmpty ? remaining.first.id : null,
      );
    }
  }
}
