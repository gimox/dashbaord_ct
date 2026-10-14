// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course_enrolled.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserCourseEnrolledCollection on Isar {
  IsarCollection<UserCourseEnrolled> get userCourseEnrolleds =>
      this.collection();
}

const UserCourseEnrolledSchema = CollectionSchema(
  name: r'UserCourseEnrolled',
  id: 1642460540378840683,
  properties: {
    r'courseId': PropertySchema(
      id: 0,
      name: r'courseId',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 1,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _userCourseEnrolledEstimateSize,
  serialize: _userCourseEnrolledSerialize,
  deserialize: _userCourseEnrolledDeserialize,
  deserializeProp: _userCourseEnrolledDeserializeProp,
  idName: r'id',
  indexes: {
    r'courseId': IndexSchema(
      id: -4937057111615935929,
      name: r'courseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'courseId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userCourseEnrolledGetId,
  getLinks: _userCourseEnrolledGetLinks,
  attach: _userCourseEnrolledAttach,
  version: '3.3.2',
);

int _userCourseEnrolledEstimateSize(
  UserCourseEnrolled object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userCourseEnrolledSerialize(
  UserCourseEnrolled object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.courseId);
  writer.writeLong(offsets[1], object.userId);
}

UserCourseEnrolled _userCourseEnrolledDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserCourseEnrolled();
  object.courseId = reader.readLongOrNull(offsets[0]);
  object.id = id;
  object.userId = reader.readLongOrNull(offsets[1]);
  return object;
}

P _userCourseEnrolledDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userCourseEnrolledGetId(UserCourseEnrolled object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userCourseEnrolledGetLinks(
    UserCourseEnrolled object) {
  return [];
}

void _userCourseEnrolledAttach(
    IsarCollection<dynamic> col, Id id, UserCourseEnrolled object) {
  object.id = id;
}

extension UserCourseEnrolledQueryWhereSort
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QWhere> {
  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhere>
      anyCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'courseId'),
      );
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhere>
      anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension UserCourseEnrolledQueryWhere
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QWhereClause> {
  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'courseId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdEqualTo(int? courseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [courseId],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdNotEqualTo(int? courseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [],
              upper: [courseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [courseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [courseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [],
              upper: [courseId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdGreaterThan(
    int? courseId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'courseId',
        lower: [courseId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdLessThan(
    int? courseId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'courseId',
        lower: [],
        upper: [courseId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      courseIdBetween(
    int? lowerCourseId,
    int? upperCourseId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'courseId',
        lower: [lowerCourseId],
        includeLower: includeLower,
        upper: [upperCourseId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdEqualTo(int? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdNotEqualTo(int? userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdGreaterThan(
    int? userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [userId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdLessThan(
    int? userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [],
        upper: [userId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterWhereClause>
      userIdBetween(
    int? lowerUserId,
    int? upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [lowerUserId],
        includeLower: includeLower,
        upper: [upperUserId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserCourseEnrolledQueryFilter
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QFilterCondition> {
  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      courseIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      courseIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      courseIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      courseIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      userIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      userIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      userIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterFilterCondition>
      userIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserCourseEnrolledQueryObject
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QFilterCondition> {}

extension UserCourseEnrolledQueryLinks
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QFilterCondition> {}

extension UserCourseEnrolledQuerySortBy
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QSortBy> {
  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserCourseEnrolledQuerySortThenBy
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QSortThenBy> {
  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserCourseEnrolledQueryWhereDistinct
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QDistinct> {
  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QDistinct>
      distinctByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId');
    });
  }

  QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension UserCourseEnrolledQueryProperty
    on QueryBuilder<UserCourseEnrolled, UserCourseEnrolled, QQueryProperty> {
  QueryBuilder<UserCourseEnrolled, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserCourseEnrolled, int?, QQueryOperations> courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<UserCourseEnrolled, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
