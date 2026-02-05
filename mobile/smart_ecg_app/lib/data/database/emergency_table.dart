import 'package:drift/drift.dart';

class EmergencyContacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
}