// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDateModelCollection on Isar {
  IsarCollection<DateModel> get dateModels => this.collection();
}

const DateModelSchema = CollectionSchema(
  name: r'DateModel',
  id: -8836198313766138647,
  properties: {
    r'completedRoutineAmount': PropertySchema(
      id: 0,
      name: r'completedRoutineAmount',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'routines': PropertySchema(
      id: 2,
      name: r'routines',
      type: IsarType.objectList,
      target: r'Routine',
    )
  },
  estimateSize: _dateModelEstimateSize,
  serialize: _dateModelSerialize,
  deserialize: _dateModelDeserialize,
  deserializeProp: _dateModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Routine': RoutineSchema},
  getId: _dateModelGetId,
  getLinks: _dateModelGetLinks,
  attach: _dateModelAttach,
  version: '3.1.8',
);

int _dateModelEstimateSize(
  DateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.routines.length * 3;
  {
    final offsets = allOffsets[Routine]!;
    for (var i = 0; i < object.routines.length; i++) {
      final value = object.routines[i];
      bytesCount += RoutineSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _dateModelSerialize(
  DateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedRoutineAmount);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeObjectList<Routine>(
    offsets[2],
    allOffsets,
    RoutineSchema.serialize,
    object.routines,
  );
}

DateModel _dateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DateModel(
    completedRoutineAmount: reader.readLong(offsets[0]),
    date: reader.readDateTime(offsets[1]),
    id: id,
    routines: reader.readObjectList<Routine>(
          offsets[2],
          RoutineSchema.deserialize,
          allOffsets,
          Routine(),
        ) ??
        [],
  );
  return object;
}

P _dateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readObjectList<Routine>(
            offset,
            RoutineSchema.deserialize,
            allOffsets,
            Routine(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dateModelGetId(DateModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dateModelGetLinks(DateModel object) {
  return [];
}

void _dateModelAttach(IsarCollection<dynamic> col, Id id, DateModel object) {
  object.id = id;
}

extension DateModelQueryWhereSort
    on QueryBuilder<DateModel, DateModel, QWhere> {
  QueryBuilder<DateModel, DateModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DateModelQueryWhere
    on QueryBuilder<DateModel, DateModel, QWhereClause> {
  QueryBuilder<DateModel, DateModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DateModelQueryFilter
    on QueryBuilder<DateModel, DateModel, QFilterCondition> {
  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      completedRoutineAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedRoutineAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      completedRoutineAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedRoutineAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      completedRoutineAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedRoutineAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      completedRoutineAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedRoutineAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routines',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> routinesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routines',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routines',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routines',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routines',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routines',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DateModelQueryObject
    on QueryBuilder<DateModel, DateModel, QFilterCondition> {
  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> routinesElement(
      FilterQuery<Routine> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'routines');
    });
  }
}

extension DateModelQueryLinks
    on QueryBuilder<DateModel, DateModel, QFilterCondition> {}

extension DateModelQuerySortBy on QueryBuilder<DateModel, DateModel, QSortBy> {
  QueryBuilder<DateModel, DateModel, QAfterSortBy>
      sortByCompletedRoutineAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedRoutineAmount', Sort.asc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy>
      sortByCompletedRoutineAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedRoutineAmount', Sort.desc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension DateModelQuerySortThenBy
    on QueryBuilder<DateModel, DateModel, QSortThenBy> {
  QueryBuilder<DateModel, DateModel, QAfterSortBy>
      thenByCompletedRoutineAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedRoutineAmount', Sort.asc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy>
      thenByCompletedRoutineAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedRoutineAmount', Sort.desc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DateModelQueryWhereDistinct
    on QueryBuilder<DateModel, DateModel, QDistinct> {
  QueryBuilder<DateModel, DateModel, QDistinct>
      distinctByCompletedRoutineAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedRoutineAmount');
    });
  }

  QueryBuilder<DateModel, DateModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension DateModelQueryProperty
    on QueryBuilder<DateModel, DateModel, QQueryProperty> {
  QueryBuilder<DateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DateModel, int, QQueryOperations>
      completedRoutineAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedRoutineAmount');
    });
  }

  QueryBuilder<DateModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DateModel, List<Routine>, QQueryOperations> routinesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routines');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RoutineSchema = Schema(
  name: r'Routine',
  id: 9144663503541703680,
  properties: {
    r'alarmActive': PropertySchema(
      id: 0,
      name: r'alarmActive',
      type: IsarType.bool,
    ),
    r'alarmTime': PropertySchema(
      id: 1,
      name: r'alarmTime',
      type: IsarType.string,
    ),
    r'colorValue': PropertySchema(
      id: 2,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'createdDate': PropertySchema(
      id: 3,
      name: r'createdDate',
      type: IsarType.dateTime,
    ),
    r'currentCount': PropertySchema(
      id: 4,
      name: r'currentCount',
      type: IsarType.long,
    ),
    r'days': PropertySchema(
      id: 5,
      name: r'days',
      type: IsarType.boolList,
    ),
    r'elapsedTimeSeconds': PropertySchema(
      id: 6,
      name: r'elapsedTimeSeconds',
      type: IsarType.long,
    ),
    r'endAt': PropertySchema(
      id: 7,
      name: r'endAt',
      type: IsarType.dateTime,
    ),
    r'finished': PropertySchema(
      id: 8,
      name: r'finished',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 9,
      name: r'id',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 10,
      name: r'name',
      type: IsarType.string,
    ),
    r'targetCount': PropertySchema(
      id: 11,
      name: r'targetCount',
      type: IsarType.long,
    ),
    r'targetDurationSeconds': PropertySchema(
      id: 12,
      name: r'targetDurationSeconds',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _routineEstimateSize,
  serialize: _routineSerialize,
  deserialize: _routineDeserialize,
  deserializeProp: _routineDeserializeProp,
);

int _routineEstimateSize(
  Routine object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.alarmTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.days;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _routineSerialize(
  Routine object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.alarmActive);
  writer.writeString(offsets[1], object.alarmTime);
  writer.writeLong(offsets[2], object.colorValue);
  writer.writeDateTime(offsets[3], object.createdDate);
  writer.writeLong(offsets[4], object.currentCount);
  writer.writeBoolList(offsets[5], object.days);
  writer.writeLong(offsets[6], object.elapsedTimeSeconds);
  writer.writeDateTime(offsets[7], object.endAt);
  writer.writeBool(offsets[8], object.finished);
  writer.writeLong(offsets[9], object.id);
  writer.writeString(offsets[10], object.name);
  writer.writeLong(offsets[11], object.targetCount);
  writer.writeLong(offsets[12], object.targetDurationSeconds);
  writer.writeString(offsets[13], object.type);
}

Routine _routineDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Routine(
    alarmActive: reader.readBoolOrNull(offsets[0]),
    alarmTime: reader.readStringOrNull(offsets[1]),
    colorValue: reader.readLongOrNull(offsets[2]),
    createdDate: reader.readDateTimeOrNull(offsets[3]),
    currentCount: reader.readLongOrNull(offsets[4]),
    days: reader.readBoolList(offsets[5]),
    elapsedTimeSeconds: reader.readLongOrNull(offsets[6]),
    endAt: reader.readDateTimeOrNull(offsets[7]),
    finished: reader.readBoolOrNull(offsets[8]),
    id: reader.readLongOrNull(offsets[9]),
    name: reader.readStringOrNull(offsets[10]),
    targetCount: reader.readLongOrNull(offsets[11]),
    targetDurationSeconds: reader.readLongOrNull(offsets[12]),
    type: reader.readStringOrNull(offsets[13]),
  );
  return object;
}

P _routineDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readBoolList(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RoutineQueryFilter
    on QueryBuilder<Routine, Routine, QFilterCondition> {
  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmActiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alarmActive',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmActiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alarmActive',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmActiveEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmActive',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alarmTime',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alarmTime',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alarmTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> alarmTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alarmTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> colorValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorValue',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> colorValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorValue',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> colorValueEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> colorValueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> colorValueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> colorValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> createdDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdDate',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> createdDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdDate',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> createdDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> createdDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> createdDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> createdDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> currentCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentCount',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      currentCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentCount',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> currentCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> currentCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> currentCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> currentCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'days',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'days',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysElementEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> daysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      elapsedTimeSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'elapsedTimeSeconds',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      elapsedTimeSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'elapsedTimeSeconds',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      elapsedTimeSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'elapsedTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      elapsedTimeSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'elapsedTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      elapsedTimeSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'elapsedTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      elapsedTimeSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'elapsedTimeSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> endAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endAt',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> endAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endAt',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> endAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> endAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> endAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> endAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> finishedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finished',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> finishedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finished',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> finishedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finished',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> targetCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetCount',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> targetCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetCount',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> targetCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> targetCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> targetCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> targetCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      targetDurationSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetDurationSeconds',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      targetDurationSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetDurationSeconds',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      targetDurationSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      targetDurationSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      targetDurationSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition>
      targetDurationSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Routine, Routine, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension RoutineQueryObject
    on QueryBuilder<Routine, Routine, QFilterCondition> {}
