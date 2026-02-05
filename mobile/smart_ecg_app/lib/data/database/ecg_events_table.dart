import 'dart:typed_data';
import 'package:drift/drift.dart';
import '../../features/ecg/ecg_event_model.dart';

class EcgEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get type => intEnum<EcgEventType>()();
  IntColumn get bpm => integer().nullable()();
  BlobColumn get ecgSnapshot => blob().nullable().map(const DoubleListBlobConverter())();
}

/// Converts a List of doubles to a byte array (Float64List) for efficient storage
class DoubleListBlobConverter extends TypeConverter<List<double>, Uint8List> {
  const DoubleListBlobConverter();

  @override
  List<double> fromSql(Uint8List fromDb) {
    return fromDb.buffer.asFloat64List().toList();
  }

  @override
  Uint8List toSql(List<double> value) {
    return Float64List.fromList(value).buffer.asUint8List();
  }
}