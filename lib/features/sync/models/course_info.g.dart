// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_info.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCourseInfoCollection on Isar {
  IsarCollection<CourseInfo> get courseInfos => this.collection();
}

const CourseInfoSchema = CollectionSchema(
  name: r'CourseInfo',
  id: -1059347495987077585,
  properties: {
    r'component': PropertySchema(
      id: 0,
      name: r'component',
      type: IsarType.string,
    ),
    r'courseId': PropertySchema(
      id: 1,
      name: r'courseId',
      type: IsarType.long,
    ),
    r'hiddenbynumsections': PropertySchema(
      id: 2,
      name: r'hiddenbynumsections',
      type: IsarType.long,
    ),
    r'itemid': PropertySchema(
      id: 3,
      name: r'itemid',
      type: IsarType.long,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 4,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'modules': PropertySchema(
      id: 5,
      name: r'modules',
      type: IsarType.objectList,
      target: r'CourseModule',
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'section': PropertySchema(
      id: 7,
      name: r'section',
      type: IsarType.long,
    ),
    r'summary': PropertySchema(
      id: 8,
      name: r'summary',
      type: IsarType.string,
    ),
    r'summaryformat': PropertySchema(
      id: 9,
      name: r'summaryformat',
      type: IsarType.long,
    ),
    r'uservisible': PropertySchema(
      id: 10,
      name: r'uservisible',
      type: IsarType.bool,
    ),
    r'visible': PropertySchema(
      id: 11,
      name: r'visible',
      type: IsarType.long,
    )
  },
  estimateSize: _courseInfoEstimateSize,
  serialize: _courseInfoSerialize,
  deserialize: _courseInfoDeserialize,
  deserializeProp: _courseInfoDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
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
    )
  },
  links: {},
  embeddedSchemas: {r'CourseModule': CourseModuleSchema},
  getId: _courseInfoGetId,
  getLinks: _courseInfoGetLinks,
  attach: _courseInfoAttach,
  version: '3.3.2',
);

int _courseInfoEstimateSize(
  CourseInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.component;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.modules;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[CourseModule]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              CourseModuleSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.summary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _courseInfoSerialize(
  CourseInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.component);
  writer.writeLong(offsets[1], object.courseId);
  writer.writeLong(offsets[2], object.hiddenbynumsections);
  writer.writeLong(offsets[3], object.itemid);
  writer.writeDateTime(offsets[4], object.lastSyncedAt);
  writer.writeObjectList<CourseModule>(
    offsets[5],
    allOffsets,
    CourseModuleSchema.serialize,
    object.modules,
  );
  writer.writeString(offsets[6], object.name);
  writer.writeLong(offsets[7], object.section);
  writer.writeString(offsets[8], object.summary);
  writer.writeLong(offsets[9], object.summaryformat);
  writer.writeBool(offsets[10], object.uservisible);
  writer.writeLong(offsets[11], object.visible);
}

CourseInfo _courseInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CourseInfo();
  object.component = reader.readStringOrNull(offsets[0]);
  object.courseId = reader.readLongOrNull(offsets[1]);
  object.hiddenbynumsections = reader.readLongOrNull(offsets[2]);
  object.id = id;
  object.itemid = reader.readLongOrNull(offsets[3]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[4]);
  object.modules = reader.readObjectList<CourseModule>(
    offsets[5],
    CourseModuleSchema.deserialize,
    allOffsets,
    CourseModule(),
  );
  object.name = reader.readStringOrNull(offsets[6]);
  object.section = reader.readLongOrNull(offsets[7]);
  object.summary = reader.readStringOrNull(offsets[8]);
  object.summaryformat = reader.readLongOrNull(offsets[9]);
  object.uservisible = reader.readBoolOrNull(offsets[10]);
  object.visible = reader.readLongOrNull(offsets[11]);
  return object;
}

P _courseInfoDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<CourseModule>(
        offset,
        CourseModuleSchema.deserialize,
        allOffsets,
        CourseModule(),
      )) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _courseInfoGetId(CourseInfo object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _courseInfoGetLinks(CourseInfo object) {
  return [];
}

void _courseInfoAttach(IsarCollection<dynamic> col, Id id, CourseInfo object) {
  object.id = id;
}

extension CourseInfoQueryWhereSort
    on QueryBuilder<CourseInfo, CourseInfo, QWhere> {
  QueryBuilder<CourseInfo, CourseInfo, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhere> anyCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'courseId'),
      );
    });
  }
}

extension CourseInfoQueryWhere
    on QueryBuilder<CourseInfo, CourseInfo, QWhereClause> {
  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> idBetween(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [null],
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> nameEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> nameNotEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'courseId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdEqualTo(
      int? courseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [courseId],
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdNotEqualTo(
      int? courseId) {
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdGreaterThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdLessThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterWhereClause> courseIdBetween(
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
}

extension CourseInfoQueryFilter
    on QueryBuilder<CourseInfo, CourseInfo, QFilterCondition> {
  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      componentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'component',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      componentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'component',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> componentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'component',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      componentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'component',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> componentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'component',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> componentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'component',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      componentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'component',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> componentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'component',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> componentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'component',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> componentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'component',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      componentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'component',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      componentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'component',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> courseIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> courseIdLessThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> courseIdBetween(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      hiddenbynumsectionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hiddenbynumsections',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      hiddenbynumsectionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hiddenbynumsections',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      hiddenbynumsectionsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hiddenbynumsections',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      hiddenbynumsectionsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hiddenbynumsections',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      hiddenbynumsectionsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hiddenbynumsections',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      hiddenbynumsectionsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hiddenbynumsections',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> itemidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemid',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      itemidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemid',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> itemidEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemid',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> itemidGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemid',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> itemidLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemid',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> itemidBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> modulesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modules',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      modulesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modules',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      modulesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modules',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> modulesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modules',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      modulesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modules',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      modulesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modules',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      modulesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modules',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      modulesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modules',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameContains(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> sectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'section',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      sectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'section',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> sectionEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      sectionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> sectionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> sectionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'section',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryformatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'summaryformat',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryformatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'summaryformat',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryformatEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryformat',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryformatGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summaryformat',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryformatLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summaryformat',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      summaryformatBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summaryformat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      uservisibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uservisible',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      uservisibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uservisible',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      uservisibleEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uservisible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> visibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'visible',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      visibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'visible',
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> visibleEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition>
      visibleGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> visibleLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> visibleBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visible',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CourseInfoQueryObject
    on QueryBuilder<CourseInfo, CourseInfo, QFilterCondition> {
  QueryBuilder<CourseInfo, CourseInfo, QAfterFilterCondition> modulesElement(
      FilterQuery<CourseModule> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'modules');
    });
  }
}

extension CourseInfoQueryLinks
    on QueryBuilder<CourseInfo, CourseInfo, QFilterCondition> {}

extension CourseInfoQuerySortBy
    on QueryBuilder<CourseInfo, CourseInfo, QSortBy> {
  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByComponent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'component', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByComponentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'component', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy>
      sortByHiddenbynumsections() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenbynumsections', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy>
      sortByHiddenbynumsectionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenbynumsections', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByItemid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemid', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByItemidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemid', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortBySummaryformat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortBySummaryformatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByUservisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uservisible', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByUservisibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uservisible', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByVisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> sortByVisibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.desc);
    });
  }
}

extension CourseInfoQuerySortThenBy
    on QueryBuilder<CourseInfo, CourseInfo, QSortThenBy> {
  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByComponent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'component', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByComponentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'component', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy>
      thenByHiddenbynumsections() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenbynumsections', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy>
      thenByHiddenbynumsectionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenbynumsections', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByItemid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemid', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByItemidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemid', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenBySummaryformat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenBySummaryformatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByUservisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uservisible', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByUservisibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uservisible', Sort.desc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByVisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.asc);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QAfterSortBy> thenByVisibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.desc);
    });
  }
}

extension CourseInfoQueryWhereDistinct
    on QueryBuilder<CourseInfo, CourseInfo, QDistinct> {
  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByComponent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'component', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct>
      distinctByHiddenbynumsections() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hiddenbynumsections');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByItemid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemid');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'section');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctBySummaryformat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summaryformat');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByUservisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uservisible');
    });
  }

  QueryBuilder<CourseInfo, CourseInfo, QDistinct> distinctByVisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visible');
    });
  }
}

extension CourseInfoQueryProperty
    on QueryBuilder<CourseInfo, CourseInfo, QQueryProperty> {
  QueryBuilder<CourseInfo, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CourseInfo, String?, QQueryOperations> componentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'component');
    });
  }

  QueryBuilder<CourseInfo, int?, QQueryOperations> courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<CourseInfo, int?, QQueryOperations>
      hiddenbynumsectionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hiddenbynumsections');
    });
  }

  QueryBuilder<CourseInfo, int?, QQueryOperations> itemidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemid');
    });
  }

  QueryBuilder<CourseInfo, DateTime?, QQueryOperations> lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<CourseInfo, List<CourseModule>?, QQueryOperations>
      modulesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modules');
    });
  }

  QueryBuilder<CourseInfo, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CourseInfo, int?, QQueryOperations> sectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'section');
    });
  }

  QueryBuilder<CourseInfo, String?, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<CourseInfo, int?, QQueryOperations> summaryformatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summaryformat');
    });
  }

  QueryBuilder<CourseInfo, bool?, QQueryOperations> uservisibleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uservisible');
    });
  }

  QueryBuilder<CourseInfo, int?, QQueryOperations> visibleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visible');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CourseModuleSchema = Schema(
  name: r'CourseModule',
  id: 9215647535862696857,
  properties: {
    r'activitybadge': PropertySchema(
      id: 0,
      name: r'activitybadge',
      type: IsarType.stringList,
    ),
    r'afterlink': PropertySchema(
      id: 1,
      name: r'afterlink',
      type: IsarType.string,
    ),
    r'availability': PropertySchema(
      id: 2,
      name: r'availability',
      type: IsarType.string,
    ),
    r'branded': PropertySchema(
      id: 3,
      name: r'branded',
      type: IsarType.bool,
    ),
    r'completion': PropertySchema(
      id: 4,
      name: r'completion',
      type: IsarType.long,
    ),
    r'contextid': PropertySchema(
      id: 5,
      name: r'contextid',
      type: IsarType.long,
    ),
    r'customdata': PropertySchema(
      id: 6,
      name: r'customdata',
      type: IsarType.string,
    ),
    r'dates': PropertySchema(
      id: 7,
      name: r'dates',
      type: IsarType.stringList,
    ),
    r'downloadcontent': PropertySchema(
      id: 8,
      name: r'downloadcontent',
      type: IsarType.long,
    ),
    r'groupmode': PropertySchema(
      id: 9,
      name: r'groupmode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 10,
      name: r'id',
      type: IsarType.long,
    ),
    r'indent': PropertySchema(
      id: 11,
      name: r'indent',
      type: IsarType.long,
    ),
    r'instance': PropertySchema(
      id: 12,
      name: r'instance',
      type: IsarType.long,
    ),
    r'modicon': PropertySchema(
      id: 13,
      name: r'modicon',
      type: IsarType.string,
    ),
    r'modname': PropertySchema(
      id: 14,
      name: r'modname',
      type: IsarType.string,
    ),
    r'modplural': PropertySchema(
      id: 15,
      name: r'modplural',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 16,
      name: r'name',
      type: IsarType.string,
    ),
    r'noviewlink': PropertySchema(
      id: 17,
      name: r'noviewlink',
      type: IsarType.bool,
    ),
    r'onclick': PropertySchema(
      id: 18,
      name: r'onclick',
      type: IsarType.string,
    ),
    r'purpose': PropertySchema(
      id: 19,
      name: r'purpose',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 20,
      name: r'url',
      type: IsarType.string,
    ),
    r'uservisible': PropertySchema(
      id: 21,
      name: r'uservisible',
      type: IsarType.bool,
    ),
    r'visible': PropertySchema(
      id: 22,
      name: r'visible',
      type: IsarType.long,
    ),
    r'visibleoncoursepage': PropertySchema(
      id: 23,
      name: r'visibleoncoursepage',
      type: IsarType.long,
    )
  },
  estimateSize: _courseModuleEstimateSize,
  serialize: _courseModuleSerialize,
  deserialize: _courseModuleDeserialize,
  deserializeProp: _courseModuleDeserializeProp,
);

int _courseModuleEstimateSize(
  CourseModule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.activitybadge;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.afterlink;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.availability;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customdata;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.dates;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.modicon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modplural;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.onclick;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purpose;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.url;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _courseModuleSerialize(
  CourseModule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.activitybadge);
  writer.writeString(offsets[1], object.afterlink);
  writer.writeString(offsets[2], object.availability);
  writer.writeBool(offsets[3], object.branded);
  writer.writeLong(offsets[4], object.completion);
  writer.writeLong(offsets[5], object.contextid);
  writer.writeString(offsets[6], object.customdata);
  writer.writeStringList(offsets[7], object.dates);
  writer.writeLong(offsets[8], object.downloadcontent);
  writer.writeLong(offsets[9], object.groupmode);
  writer.writeLong(offsets[10], object.id);
  writer.writeLong(offsets[11], object.indent);
  writer.writeLong(offsets[12], object.instance);
  writer.writeString(offsets[13], object.modicon);
  writer.writeString(offsets[14], object.modname);
  writer.writeString(offsets[15], object.modplural);
  writer.writeString(offsets[16], object.name);
  writer.writeBool(offsets[17], object.noviewlink);
  writer.writeString(offsets[18], object.onclick);
  writer.writeString(offsets[19], object.purpose);
  writer.writeString(offsets[20], object.url);
  writer.writeBool(offsets[21], object.uservisible);
  writer.writeLong(offsets[22], object.visible);
  writer.writeLong(offsets[23], object.visibleoncoursepage);
}

CourseModule _courseModuleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CourseModule();
  object.activitybadge = reader.readStringList(offsets[0]);
  object.afterlink = reader.readStringOrNull(offsets[1]);
  object.availability = reader.readStringOrNull(offsets[2]);
  object.branded = reader.readBoolOrNull(offsets[3]);
  object.completion = reader.readLongOrNull(offsets[4]);
  object.contextid = reader.readLongOrNull(offsets[5]);
  object.customdata = reader.readStringOrNull(offsets[6]);
  object.dates = reader.readStringList(offsets[7]);
  object.downloadcontent = reader.readLongOrNull(offsets[8]);
  object.groupmode = reader.readLongOrNull(offsets[9]);
  object.id = reader.readLongOrNull(offsets[10]);
  object.indent = reader.readLongOrNull(offsets[11]);
  object.instance = reader.readLongOrNull(offsets[12]);
  object.modicon = reader.readStringOrNull(offsets[13]);
  object.modname = reader.readStringOrNull(offsets[14]);
  object.modplural = reader.readStringOrNull(offsets[15]);
  object.name = reader.readStringOrNull(offsets[16]);
  object.noviewlink = reader.readBoolOrNull(offsets[17]);
  object.onclick = reader.readStringOrNull(offsets[18]);
  object.purpose = reader.readStringOrNull(offsets[19]);
  object.url = reader.readStringOrNull(offsets[20]);
  object.uservisible = reader.readBoolOrNull(offsets[21]);
  object.visible = reader.readLongOrNull(offsets[22]);
  object.visibleoncoursepage = reader.readLongOrNull(offsets[23]);
  return object;
}

P _courseModuleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readBoolOrNull(offset)) as P;
    case 22:
      return (reader.readLongOrNull(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CourseModuleQueryFilter
    on QueryBuilder<CourseModule, CourseModule, QFilterCondition> {
  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activitybadge',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activitybadge',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activitybadge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activitybadge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activitybadge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activitybadge',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activitybadge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activitybadge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activitybadge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activitybadge',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activitybadge',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activitybadge',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activitybadge',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activitybadge',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activitybadge',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activitybadge',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activitybadge',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      activitybadgeLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activitybadge',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'afterlink',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'afterlink',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afterlink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'afterlink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'afterlink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'afterlink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'afterlink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'afterlink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'afterlink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'afterlink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afterlink',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      afterlinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'afterlink',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'availability',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'availability',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availability',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availability',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availability',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availability',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'availability',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'availability',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'availability',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'availability',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availability',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      availabilityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'availability',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      brandedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'branded',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      brandedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'branded',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      brandedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branded',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      completionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completion',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      completionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completion',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      completionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completion',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      completionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completion',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      completionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completion',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      completionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      contextidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contextid',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      contextidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contextid',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      contextidEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextid',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      contextidGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contextid',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      contextidLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contextid',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      contextidBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contextid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customdata',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customdata',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customdata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customdata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customdata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customdata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customdata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customdata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customdata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customdata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customdata',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      customdataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customdata',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dates',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dates',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dates',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dates',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      datesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      downloadcontentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadcontent',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      downloadcontentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadcontent',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      downloadcontentEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadcontent',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      downloadcontentGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadcontent',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      downloadcontentLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadcontent',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      downloadcontentBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadcontent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      groupmodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupmode',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      groupmodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupmode',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      groupmodeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupmode',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      groupmodeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupmode',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      groupmodeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupmode',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      groupmodeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupmode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> idEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      indentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'indent',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      indentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'indent',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> indentEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'indent',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      indentGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'indent',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      indentLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'indent',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> indentBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'indent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      instanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'instance',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      instanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'instance',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      instanceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instance',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      instanceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'instance',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      instanceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'instance',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      instanceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'instance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modicon',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modicon',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modicon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modicon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modicon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modicon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modicon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modicon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modicon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modicon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modicon',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modiconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modicon',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modname',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modname',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modname',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modname',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modplural',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modplural',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modplural',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modplural',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modplural',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modplural',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modplural',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modplural',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modplural',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modplural',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modplural',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      modpluralIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modplural',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameContains(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      noviewlinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'noviewlink',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      noviewlinkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'noviewlink',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      noviewlinkEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noviewlink',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'onclick',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'onclick',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onclick',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'onclick',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'onclick',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'onclick',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'onclick',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'onclick',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'onclick',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'onclick',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onclick',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      onclickIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'onclick',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purpose',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purpose',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purpose',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purpose',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purpose',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      purposeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purpose',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      urlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      urlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      uservisibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uservisible',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      uservisibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uservisible',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      uservisibleEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uservisible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'visible',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'visible',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visible',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleoncoursepageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'visibleoncoursepage',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleoncoursepageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'visibleoncoursepage',
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleoncoursepageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visibleoncoursepage',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleoncoursepageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visibleoncoursepage',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleoncoursepageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visibleoncoursepage',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseModule, CourseModule, QAfterFilterCondition>
      visibleoncoursepageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visibleoncoursepage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CourseModuleQueryObject
    on QueryBuilder<CourseModule, CourseModule, QFilterCondition> {}
