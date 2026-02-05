import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/database_provider.dart';
import 'ecg_event_model.dart';

final ecgEventRepositoryProvider = Provider<EcgEventRepository>(
  (ref) => EcgEventRepository(
    ref.read(appDatabaseProvider),
  ),
);

class EcgEventRepository {
  final AppDatabase _db;

  EcgEventRepository(this._db);

  Stream<List<EcgEventModel>> watchEvents() {
    return (_db.select(_db.ecgEvents)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => EcgEventModel(
                  id: r.id,
                  timestamp: r.timestamp,
                  type: r.type,
                  bpm: r.bpm,
                  snapshot: r.ecgSnapshot,
                ),
              )
              .toList(),
        );
  }

  /// Persist a fully-formed ECG event
  Future<void> insertEvent(EcgEventModel event) async {
    await _db.into(_db.ecgEvents).insert(
          EcgEventsCompanion.insert(
            timestamp: event.timestamp,
            type: event.type,
            bpm: Value(event.bpm),
            ecgSnapshot: Value(event.snapshot),
          ),
        );
  }

  Future<void> deleteEvent(int id) async {
    await (_db.delete(_db.ecgEvents)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearAllEvents() async {
    await _db.delete(_db.ecgEvents).go();
  }
}