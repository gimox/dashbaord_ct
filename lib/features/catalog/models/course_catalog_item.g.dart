// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_catalog_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCourseCatalogItemCollection on Isar {
  IsarCollection<CourseCatalogItem> get courseCatalogItems => this.collection();
}

const CourseCatalogItemSchema = CollectionSchema(
  name: r'CourseCatalogItem',
  id: 6373470137725312187,
  properties: {
    r'courseCode': PropertySchema(
      id: 0,
      name: r'courseCode',
      type: IsarType.string,
    ),
    r'courseId': PropertySchema(
      id: 1,
      name: r'courseId',
      type: IsarType.long,
    ),
    r'courseShortname': PropertySchema(
      id: 2,
      name: r'courseShortname',
      type: IsarType.string,
    ),
    r'courseType': PropertySchema(
      id: 3,
      name: r'courseType',
      type: IsarType.string,
    ),
    r'durationHours': PropertySchema(
      id: 4,
      name: r'durationHours',
      type: IsarType.double,
    ),
    r'individualStudyHours': PropertySchema(
      id: 5,
      name: r'individualStudyHours',
      type: IsarType.double,
    ),
    r'learningPath': PropertySchema(
      id: 6,
      name: r'learningPath',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 8,
      name: r'title',
      type: IsarType.string,
    ),
    r'titleIt': PropertySchema(
      id: 9,
      name: r'titleIt',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _courseCatalogItemEstimateSize,
  serialize: _courseCatalogItemSerialize,
  deserialize: _courseCatalogItemDeserialize,
  deserializeProp: _courseCatalogItemDeserializeProp,
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
    r'courseCode': IndexSchema(
      id: -3801750468446762910,
      name: r'courseCode',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'courseCode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _courseCatalogItemGetId,
  getLinks: _courseCatalogItemGetLinks,
  attach: _courseCatalogItemAttach,
  version: '3.3.2',
);

int _courseCatalogItemEstimateSize(
  CourseCatalogItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.courseCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.courseShortname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.courseType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.learningPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.titleIt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _courseCatalogItemSerialize(
  CourseCatalogItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseCode);
  writer.writeLong(offsets[1], object.courseId);
  writer.writeString(offsets[2], object.courseShortname);
  writer.writeString(offsets[3], object.courseType);
  writer.writeDouble(offsets[4], object.durationHours);
  writer.writeDouble(offsets[5], object.individualStudyHours);
  writer.writeString(offsets[6], object.learningPath);
  writer.writeString(offsets[7], object.notes);
  writer.writeString(offsets[8], object.title);
  writer.writeString(offsets[9], object.titleIt);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

CourseCatalogItem _courseCatalogItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CourseCatalogItem();
  object.courseCode = reader.readStringOrNull(offsets[0]);
  object.courseId = reader.readLongOrNull(offsets[1]);
  object.courseShortname = reader.readStringOrNull(offsets[2]);
  object.courseType = reader.readStringOrNull(offsets[3]);
  object.durationHours = reader.readDoubleOrNull(offsets[4]);
  object.id = id;
  object.individualStudyHours = reader.readDoubleOrNull(offsets[5]);
  object.learningPath = reader.readStringOrNull(offsets[6]);
  object.notes = reader.readStringOrNull(offsets[7]);
  object.title = reader.readStringOrNull(offsets[8]);
  object.titleIt = reader.readStringOrNull(offsets[9]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[10]);
  return object;
}

P _courseCatalogItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _courseCatalogItemGetId(CourseCatalogItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _courseCatalogItemGetLinks(
    CourseCatalogItem object) {
  return [];
}

void _courseCatalogItemAttach(
    IsarCollection<dynamic> col, Id id, CourseCatalogItem object) {
  object.id = id;
}

extension CourseCatalogItemByIndex on IsarCollection<CourseCatalogItem> {
  Future<CourseCatalogItem?> getByCourseCode(String? courseCode) {
    return getByIndex(r'courseCode', [courseCode]);
  }

  CourseCatalogItem? getByCourseCodeSync(String? courseCode) {
    return getByIndexSync(r'courseCode', [courseCode]);
  }

  Future<bool> deleteByCourseCode(String? courseCode) {
    return deleteByIndex(r'courseCode', [courseCode]);
  }

  bool deleteByCourseCodeSync(String? courseCode) {
    return deleteByIndexSync(r'courseCode', [courseCode]);
  }

  Future<List<CourseCatalogItem?>> getAllByCourseCode(
      List<String?> courseCodeValues) {
    final values = courseCodeValues.map((e) => [e]).toList();
    return getAllByIndex(r'courseCode', values);
  }

  List<CourseCatalogItem?> getAllByCourseCodeSync(
      List<String?> courseCodeValues) {
    final values = courseCodeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'courseCode', values);
  }

  Future<int> deleteAllByCourseCode(List<String?> courseCodeValues) {
    final values = courseCodeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'courseCode', values);
  }

  int deleteAllByCourseCodeSync(List<String?> courseCodeValues) {
    final values = courseCodeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'courseCode', values);
  }

  Future<Id> putByCourseCode(CourseCatalogItem object) {
    return putByIndex(r'courseCode', object);
  }

  Id putByCourseCodeSync(CourseCatalogItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'courseCode', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCourseCode(List<CourseCatalogItem> objects) {
    return putAllByIndex(r'courseCode', objects);
  }

  List<Id> putAllByCourseCodeSync(List<CourseCatalogItem> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'courseCode', objects, saveLinks: saveLinks);
  }
}

extension CourseCatalogItemQueryWhereSort
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QWhere> {
  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhere>
      anyCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'courseId'),
      );
    });
  }
}

extension CourseCatalogItemQueryWhere
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QWhereClause> {
  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      courseIdEqualTo(int? courseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [courseId],
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      courseCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseCode',
        value: [null],
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      courseCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'courseCode',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      courseCodeEqualTo(String? courseCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseCode',
        value: [courseCode],
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterWhereClause>
      courseCodeNotEqualTo(String? courseCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseCode',
              lower: [],
              upper: [courseCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseCode',
              lower: [courseCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseCode',
              lower: [courseCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseCode',
              lower: [],
              upper: [courseCode],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CourseCatalogItemQueryFilter
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QFilterCondition> {
  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseCode',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseCode',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseShortname',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseShortname',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseShortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseShortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseShortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseShortname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseShortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseShortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseShortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseShortname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseShortname',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseShortnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseShortname',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseType',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseType',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseType',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      courseTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseType',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      durationHoursIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationHours',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      durationHoursIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationHours',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      durationHoursEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      durationHoursGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      durationHoursLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      durationHoursBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
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

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      individualStudyHoursIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'individualStudyHours',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      individualStudyHoursIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'individualStudyHours',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      individualStudyHoursEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'individualStudyHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      individualStudyHoursGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'individualStudyHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      individualStudyHoursLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'individualStudyHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      individualStudyHoursBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'individualStudyHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'learningPath',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'learningPath',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'learningPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'learningPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'learningPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'learningPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'learningPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'learningPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'learningPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningPath',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      learningPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'learningPath',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'titleIt',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'titleIt',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleIt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleIt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleIt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleIt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleIt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleIt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleIt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleIt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleIt',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      titleItIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleIt',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CourseCatalogItemQueryObject
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QFilterCondition> {}

extension CourseCatalogItemQueryLinks
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QFilterCondition> {}

extension CourseCatalogItemQuerySortBy
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QSortBy> {
  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseShortname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseShortname', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseShortnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseShortname', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseType', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByCourseTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseType', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByIndividualStudyHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'individualStudyHours', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByIndividualStudyHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'individualStudyHours', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByLearningPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningPath', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByLearningPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningPath', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByTitleIt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleIt', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByTitleItDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleIt', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CourseCatalogItemQuerySortThenBy
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QSortThenBy> {
  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseShortname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseShortname', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseShortnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseShortname', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseType', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByCourseTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseType', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByIndividualStudyHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'individualStudyHours', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByIndividualStudyHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'individualStudyHours', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByLearningPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningPath', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByLearningPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningPath', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByTitleIt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleIt', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByTitleItDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleIt', Sort.desc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CourseCatalogItemQueryWhereDistinct
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct> {
  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByCourseCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId');
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByCourseShortname({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseShortname',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByCourseType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationHours');
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByIndividualStudyHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'individualStudyHours');
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByLearningPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByTitleIt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleIt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseCatalogItem, CourseCatalogItem, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CourseCatalogItemQueryProperty
    on QueryBuilder<CourseCatalogItem, CourseCatalogItem, QQueryProperty> {
  QueryBuilder<CourseCatalogItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations>
      courseCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseCode');
    });
  }

  QueryBuilder<CourseCatalogItem, int?, QQueryOperations> courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations>
      courseShortnameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseShortname');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations>
      courseTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseType');
    });
  }

  QueryBuilder<CourseCatalogItem, double?, QQueryOperations>
      durationHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationHours');
    });
  }

  QueryBuilder<CourseCatalogItem, double?, QQueryOperations>
      individualStudyHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'individualStudyHours');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations>
      learningPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningPath');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<CourseCatalogItem, String?, QQueryOperations> titleItProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleIt');
    });
  }

  QueryBuilder<CourseCatalogItem, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
