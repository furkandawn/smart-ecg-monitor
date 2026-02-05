import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'emergency_table.dart';
import 'ecg_events_table.dart';
import '../../features/ecg/ecg_event_model.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  EmergencyContacts,
  EcgEvents,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;
  
  /* ───────── ECG Events ───────── */
  
  Stream<List<EcgEvent>> watchAllEvents() =>
      (select(ecgEvents)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).watch();

  Future<EcgEvent?> getEventById(int id) =>
      (select(ecgEvents)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertEvent(EcgEventsCompanion entry) =>
      into(ecgEvents).insert(entry);

  Future<int> deleteEvent(int id) =>
      (delete(ecgEvents)..where((t) => t.id.equals(id))).go();
  

  /* ───────── Emergency Contacts ───────── */

  Stream<List<EmergencyContact>> watchContacts() =>
      (select(emergencyContacts)
            ..orderBy([
              (t) => OrderingTerm.asc(t.name),
            ]))
          .watch();

  Future<int> addContact({
    required String name,
    required String phone,
  }) {
    return into(emergencyContacts).insert(
      EmergencyContactsCompanion.insert(
        name: name,
        phone: phone,
      ),
    );
  }

  Future<void> deleteContact(int id) {
    return (delete(emergencyContacts)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

/* ───────── Database Loader ───────── */

LazyDatabase _open() {
  return LazyDatabase(() async {
    return driftDatabase(
      name: 'smart_ecg.db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  });
}

/* EcgEvents Table is handled at "lib/features/ecg/ecg_event_repository.dart" */