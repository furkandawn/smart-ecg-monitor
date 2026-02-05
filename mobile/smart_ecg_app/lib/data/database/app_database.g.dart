// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmergencyContactsTable extends EmergencyContacts
    with TableInfo<$EmergencyContactsTable, EmergencyContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyContact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyContact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
    );
  }

  @override
  $EmergencyContactsTable createAlias(String alias) {
    return $EmergencyContactsTable(attachedDatabase, alias);
  }
}

class EmergencyContact extends DataClass
    implements Insertable<EmergencyContact> {
  final int id;
  final String name;
  final String phone;
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    return map;
  }

  EmergencyContactsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyContactsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
    );
  }

  factory EmergencyContact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyContact(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
    };
  }

  EmergencyContact copyWith({int? id, String? name, String? phone}) =>
      EmergencyContact(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
      );
  EmergencyContact copyWithCompanion(EmergencyContactsCompanion data) {
    return EmergencyContact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyContact &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone);
}

class EmergencyContactsCompanion extends UpdateCompanion<EmergencyContact> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  const EmergencyContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
  });
  EmergencyContactsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
  }) : name = Value(name),
       phone = Value(phone);
  static Insertable<EmergencyContact> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
    });
  }

  EmergencyContactsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
  }) {
    return EmergencyContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }
}

class $EcgEventsTable extends EcgEvents
    with TableInfo<$EcgEventsTable, EcgEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EcgEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EcgEventType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<EcgEventType>($EcgEventsTable.$convertertype);
  static const VerificationMeta _bpmMeta = const VerificationMeta('bpm');
  @override
  late final GeneratedColumn<int> bpm = GeneratedColumn<int>(
    'bpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<double>?, Uint8List>
  ecgSnapshot = GeneratedColumn<Uint8List>(
    'ecg_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  ).withConverter<List<double>?>($EcgEventsTable.$converterecgSnapshotn);
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, type, bpm, ecgSnapshot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ecg_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EcgEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('bpm')) {
      context.handle(
        _bpmMeta,
        bpm.isAcceptableOrUnknown(data['bpm']!, _bpmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EcgEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EcgEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      type: $EcgEventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      bpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bpm'],
      ),
      ecgSnapshot: $EcgEventsTable.$converterecgSnapshotn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.blob,
          data['${effectivePrefix}ecg_snapshot'],
        ),
      ),
    );
  }

  @override
  $EcgEventsTable createAlias(String alias) {
    return $EcgEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EcgEventType, int, int> $convertertype =
      const EnumIndexConverter<EcgEventType>(EcgEventType.values);
  static TypeConverter<List<double>, Uint8List> $converterecgSnapshot =
      const DoubleListBlobConverter();
  static TypeConverter<List<double>?, Uint8List?> $converterecgSnapshotn =
      NullAwareTypeConverter.wrap($converterecgSnapshot);
}

class EcgEvent extends DataClass implements Insertable<EcgEvent> {
  final int id;
  final DateTime timestamp;
  final EcgEventType type;
  final int? bpm;
  final List<double>? ecgSnapshot;
  const EcgEvent({
    required this.id,
    required this.timestamp,
    required this.type,
    this.bpm,
    this.ecgSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['type'] = Variable<int>($EcgEventsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || bpm != null) {
      map['bpm'] = Variable<int>(bpm);
    }
    if (!nullToAbsent || ecgSnapshot != null) {
      map['ecg_snapshot'] = Variable<Uint8List>(
        $EcgEventsTable.$converterecgSnapshotn.toSql(ecgSnapshot),
      );
    }
    return map;
  }

  EcgEventsCompanion toCompanion(bool nullToAbsent) {
    return EcgEventsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      type: Value(type),
      bpm: bpm == null && nullToAbsent ? const Value.absent() : Value(bpm),
      ecgSnapshot: ecgSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(ecgSnapshot),
    );
  }

  factory EcgEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EcgEvent(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      type: $EcgEventsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      bpm: serializer.fromJson<int?>(json['bpm']),
      ecgSnapshot: serializer.fromJson<List<double>?>(json['ecgSnapshot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'type': serializer.toJson<int>(
        $EcgEventsTable.$convertertype.toJson(type),
      ),
      'bpm': serializer.toJson<int?>(bpm),
      'ecgSnapshot': serializer.toJson<List<double>?>(ecgSnapshot),
    };
  }

  EcgEvent copyWith({
    int? id,
    DateTime? timestamp,
    EcgEventType? type,
    Value<int?> bpm = const Value.absent(),
    Value<List<double>?> ecgSnapshot = const Value.absent(),
  }) => EcgEvent(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    type: type ?? this.type,
    bpm: bpm.present ? bpm.value : this.bpm,
    ecgSnapshot: ecgSnapshot.present ? ecgSnapshot.value : this.ecgSnapshot,
  );
  EcgEvent copyWithCompanion(EcgEventsCompanion data) {
    return EcgEvent(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      type: data.type.present ? data.type.value : this.type,
      bpm: data.bpm.present ? data.bpm.value : this.bpm,
      ecgSnapshot: data.ecgSnapshot.present
          ? data.ecgSnapshot.value
          : this.ecgSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EcgEvent(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('bpm: $bpm, ')
          ..write('ecgSnapshot: $ecgSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, type, bpm, ecgSnapshot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EcgEvent &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.type == this.type &&
          other.bpm == this.bpm &&
          other.ecgSnapshot == this.ecgSnapshot);
}

class EcgEventsCompanion extends UpdateCompanion<EcgEvent> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<EcgEventType> type;
  final Value<int?> bpm;
  final Value<List<double>?> ecgSnapshot;
  const EcgEventsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.type = const Value.absent(),
    this.bpm = const Value.absent(),
    this.ecgSnapshot = const Value.absent(),
  });
  EcgEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required EcgEventType type,
    this.bpm = const Value.absent(),
    this.ecgSnapshot = const Value.absent(),
  }) : timestamp = Value(timestamp),
       type = Value(type);
  static Insertable<EcgEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? type,
    Expression<int>? bpm,
    Expression<Uint8List>? ecgSnapshot,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (bpm != null) 'bpm': bpm,
      if (ecgSnapshot != null) 'ecg_snapshot': ecgSnapshot,
    });
  }

  EcgEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<EcgEventType>? type,
    Value<int?>? bpm,
    Value<List<double>?>? ecgSnapshot,
  }) {
    return EcgEventsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      bpm: bpm ?? this.bpm,
      ecgSnapshot: ecgSnapshot ?? this.ecgSnapshot,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $EcgEventsTable.$convertertype.toSql(type.value),
      );
    }
    if (bpm.present) {
      map['bpm'] = Variable<int>(bpm.value);
    }
    if (ecgSnapshot.present) {
      map['ecg_snapshot'] = Variable<Uint8List>(
        $EcgEventsTable.$converterecgSnapshotn.toSql(ecgSnapshot.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EcgEventsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('bpm: $bpm, ')
          ..write('ecgSnapshot: $ecgSnapshot')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmergencyContactsTable emergencyContacts =
      $EmergencyContactsTable(this);
  late final $EcgEventsTable ecgEvents = $EcgEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    emergencyContacts,
    ecgEvents,
  ];
}

typedef $$EmergencyContactsTableCreateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
    });
typedef $$EmergencyContactsTableUpdateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
    });

class $$EmergencyContactsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);
}

class $$EmergencyContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContact,
          $$EmergencyContactsTableFilterComposer,
          $$EmergencyContactsTableOrderingComposer,
          $$EmergencyContactsTableAnnotationComposer,
          $$EmergencyContactsTableCreateCompanionBuilder,
          $$EmergencyContactsTableUpdateCompanionBuilder,
          (
            EmergencyContact,
            BaseReferences<
              _$AppDatabase,
              $EmergencyContactsTable,
              EmergencyContact
            >,
          ),
          EmergencyContact,
          PrefetchHooks Function()
        > {
  $$EmergencyContactsTableTableManager(
    _$AppDatabase db,
    $EmergencyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
              }) =>
                  EmergencyContactsCompanion(id: id, name: name, phone: phone),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
              }) => EmergencyContactsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmergencyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyContactsTable,
      EmergencyContact,
      $$EmergencyContactsTableFilterComposer,
      $$EmergencyContactsTableOrderingComposer,
      $$EmergencyContactsTableAnnotationComposer,
      $$EmergencyContactsTableCreateCompanionBuilder,
      $$EmergencyContactsTableUpdateCompanionBuilder,
      (
        EmergencyContact,
        BaseReferences<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContact
        >,
      ),
      EmergencyContact,
      PrefetchHooks Function()
    >;
typedef $$EcgEventsTableCreateCompanionBuilder =
    EcgEventsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required EcgEventType type,
      Value<int?> bpm,
      Value<List<double>?> ecgSnapshot,
    });
typedef $$EcgEventsTableUpdateCompanionBuilder =
    EcgEventsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<EcgEventType> type,
      Value<int?> bpm,
      Value<List<double>?> ecgSnapshot,
    });

class $$EcgEventsTableFilterComposer
    extends Composer<_$AppDatabase, $EcgEventsTable> {
  $$EcgEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EcgEventType, EcgEventType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get bpm => $composableBuilder(
    column: $table.bpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<double>?, List<double>, Uint8List>
  get ecgSnapshot => $composableBuilder(
    column: $table.ecgSnapshot,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$EcgEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EcgEventsTable> {
  $$EcgEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bpm => $composableBuilder(
    column: $table.bpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get ecgSnapshot => $composableBuilder(
    column: $table.ecgSnapshot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EcgEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EcgEventsTable> {
  $$EcgEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EcgEventType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get bpm =>
      $composableBuilder(column: $table.bpm, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<double>?, Uint8List> get ecgSnapshot =>
      $composableBuilder(
        column: $table.ecgSnapshot,
        builder: (column) => column,
      );
}

class $$EcgEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EcgEventsTable,
          EcgEvent,
          $$EcgEventsTableFilterComposer,
          $$EcgEventsTableOrderingComposer,
          $$EcgEventsTableAnnotationComposer,
          $$EcgEventsTableCreateCompanionBuilder,
          $$EcgEventsTableUpdateCompanionBuilder,
          (EcgEvent, BaseReferences<_$AppDatabase, $EcgEventsTable, EcgEvent>),
          EcgEvent,
          PrefetchHooks Function()
        > {
  $$EcgEventsTableTableManager(_$AppDatabase db, $EcgEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EcgEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EcgEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EcgEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<EcgEventType> type = const Value.absent(),
                Value<int?> bpm = const Value.absent(),
                Value<List<double>?> ecgSnapshot = const Value.absent(),
              }) => EcgEventsCompanion(
                id: id,
                timestamp: timestamp,
                type: type,
                bpm: bpm,
                ecgSnapshot: ecgSnapshot,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required EcgEventType type,
                Value<int?> bpm = const Value.absent(),
                Value<List<double>?> ecgSnapshot = const Value.absent(),
              }) => EcgEventsCompanion.insert(
                id: id,
                timestamp: timestamp,
                type: type,
                bpm: bpm,
                ecgSnapshot: ecgSnapshot,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EcgEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EcgEventsTable,
      EcgEvent,
      $$EcgEventsTableFilterComposer,
      $$EcgEventsTableOrderingComposer,
      $$EcgEventsTableAnnotationComposer,
      $$EcgEventsTableCreateCompanionBuilder,
      $$EcgEventsTableUpdateCompanionBuilder,
      (EcgEvent, BaseReferences<_$AppDatabase, $EcgEventsTable, EcgEvent>),
      EcgEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmergencyContactsTableTableManager get emergencyContacts =>
      $$EmergencyContactsTableTableManager(_db, _db.emergencyContacts);
  $$EcgEventsTableTableManager get ecgEvents =>
      $$EcgEventsTableTableManager(_db, _db.ecgEvents);
}
