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
    r'routinesId': PropertySchema(
      id: 2,
      name: r'routinesId',
      type: IsarType.longList,
    )
  },
  estimateSize: _dateModelEstimateSize,
  serialize: _dateModelSerialize,
  deserialize: _dateModelDeserialize,
  deserializeProp: _dateModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
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
  bytesCount += 3 + object.routinesId.length * 8;
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
  writer.writeLongList(offsets[2], object.routinesId);
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
    routinesId: reader.readLongList(offsets[2]) ?? [],
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
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dateModelGetId(DateModel object) {
  return object.id;
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

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
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
    Id value, {
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
    Id lower,
    Id upper, {
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
      routinesIdElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routinesId',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routinesId',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routinesId',
        value: value,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routinesId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routinesId',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routinesId',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routinesId',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routinesId',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routinesId',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DateModel, DateModel, QAfterFilterCondition>
      routinesIdLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routinesId',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DateModelQueryObject
    on QueryBuilder<DateModel, DateModel, QFilterCondition> {}

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

  QueryBuilder<DateModel, DateModel, QDistinct> distinctByRoutinesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routinesId');
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

  QueryBuilder<DateModel, List<int>, QQueryOperations> routinesIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routinesId');
    });
  }
}
