import '../../data/database/app_database.dart';
import '../../data/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emergencyContactsRepositoryProvider =
    Provider<EmergencyContactsRepository>((ref) {
  return EmergencyContactsRepository(ref.read(appDatabaseProvider));
});

class EmergencyContactsRepository {
  final AppDatabase _db;

  EmergencyContactsRepository(this._db);

  Stream<List<EmergencyContact>> watchContacts() {
    return _db.watchContacts();
  }

  Future<int> addContact({
    required String name,
    required String phone,
  }) {
    return _db.addContact(name: name, phone: phone);
  }

  Future<void> deleteContact(int id) {
    return _db.deleteContact(id);
  }
}
