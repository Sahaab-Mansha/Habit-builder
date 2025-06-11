// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserHabits.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserHabitsCollection on Isar {
  IsarCollection<UserHabits> get userHabits => this.collection();
}

const UserHabitsSchema = CollectionSchema(
  name: r'UserHabits',
  id: -1681910583682539485,
  properties: {
    r'habits': PropertySchema(
      id: 0,
      name: r'habits',
      type: IsarType.objectList,
      target: r'Habit',
    ),
    r'userId': PropertySchema(
      id: 1,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _userHabitsEstimateSize,
  serialize: _userHabitsSerialize,
  deserialize: _userHabitsDeserialize,
  deserializeProp: _userHabitsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Habit': HabitSchema},
  getId: _userHabitsGetId,
  getLinks: _userHabitsGetLinks,
  attach: _userHabitsAttach,
  version: '3.1.0+1',
);

int _userHabitsEstimateSize(
  UserHabits object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.habits.length * 3;
  {
    final offsets = allOffsets[Habit]!;
    for (var i = 0; i < object.habits.length; i++) {
      final value = object.habits[i];
      bytesCount += HabitSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _userHabitsSerialize(
  UserHabits object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Habit>(
    offsets[0],
    allOffsets,
    HabitSchema.serialize,
    object.habits,
  );
  writer.writeString(offsets[1], object.userId);
}

UserHabits _userHabitsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserHabits();
  object.habits = reader.readObjectList<Habit>(
        offsets[0],
        HabitSchema.deserialize,
        allOffsets,
        Habit(),
      ) ??
      [];
  object.id = id;
  object.userId = reader.readString(offsets[1]);
  return object;
}

P _userHabitsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Habit>(
            offset,
            HabitSchema.deserialize,
            allOffsets,
            Habit(),
          ) ??
          []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userHabitsGetId(UserHabits object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userHabitsGetLinks(UserHabits object) {
  return [];
}

void _userHabitsAttach(IsarCollection<dynamic> col, Id id, UserHabits object) {
  object.id = id;
}

extension UserHabitsQueryWhereSort
    on QueryBuilder<UserHabits, UserHabits, QWhere> {
  QueryBuilder<UserHabits, UserHabits, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserHabitsQueryWhere
    on QueryBuilder<UserHabits, UserHabits, QWhereClause> {
  QueryBuilder<UserHabits, UserHabits, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserHabits, UserHabits, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterWhereClause> idBetween(
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

extension UserHabitsQueryFilter
    on QueryBuilder<UserHabits, UserHabits, QFilterCondition> {
  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition>
      habitsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habits',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> habitsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habits',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition>
      habitsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habits',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition>
      habitsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habits',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition>
      habitsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habits',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition>
      habitsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habits',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension UserHabitsQueryObject
    on QueryBuilder<UserHabits, UserHabits, QFilterCondition> {
  QueryBuilder<UserHabits, UserHabits, QAfterFilterCondition> habitsElement(
      FilterQuery<Habit> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'habits');
    });
  }
}

extension UserHabitsQueryLinks
    on QueryBuilder<UserHabits, UserHabits, QFilterCondition> {}

extension UserHabitsQuerySortBy
    on QueryBuilder<UserHabits, UserHabits, QSortBy> {
  QueryBuilder<UserHabits, UserHabits, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserHabitsQuerySortThenBy
    on QueryBuilder<UserHabits, UserHabits, QSortThenBy> {
  QueryBuilder<UserHabits, UserHabits, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserHabits, UserHabits, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserHabitsQueryWhereDistinct
    on QueryBuilder<UserHabits, UserHabits, QDistinct> {
  QueryBuilder<UserHabits, UserHabits, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension UserHabitsQueryProperty
    on QueryBuilder<UserHabits, UserHabits, QQueryProperty> {
  QueryBuilder<UserHabits, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserHabits, List<Habit>, QQueryOperations> habitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habits');
    });
  }

  QueryBuilder<UserHabits, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
