// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_for_bi.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFeedbackForBiCollection on Isar {
  IsarCollection<FeedbackForBi> get feedbackForBis => this.collection();
}

const FeedbackForBiSchema = CollectionSchema(
  name: r'FeedbackForBi',
  id: 5504199868422236026,
  properties: {
    r'courseId': PropertySchema(
      id: 0,
      name: r'courseId',
      type: IsarType.long,
    ),
    r'courseName': PropertySchema(
      id: 1,
      name: r'courseName',
      type: IsarType.string,
    ),
    r'feedbackName': PropertySchema(
      id: 2,
      name: r'feedbackName',
      type: IsarType.string,
    ),
    r'hq1': PropertySchema(
      id: 3,
      name: r'hq1',
      type: IsarType.long,
    ),
    r'hq2': PropertySchema(
      id: 4,
      name: r'hq2',
      type: IsarType.long,
    ),
    r'hq3': PropertySchema(
      id: 5,
      name: r'hq3',
      type: IsarType.long,
    ),
    r'hq4': PropertySchema(
      id: 6,
      name: r'hq4',
      type: IsarType.long,
    ),
    r'lang': PropertySchema(
      id: 7,
      name: r'lang',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 8,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _feedbackForBiEstimateSize,
  serialize: _feedbackForBiSerialize,
  deserialize: _feedbackForBiDeserialize,
  deserializeProp: _feedbackForBiDeserializeProp,
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
    r'lang': IndexSchema(
      id: -2758126360748105940,
      name: r'lang',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lang',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _feedbackForBiGetId,
  getLinks: _feedbackForBiGetLinks,
  attach: _feedbackForBiAttach,
  version: '3.3.2',
);

int _feedbackForBiEstimateSize(
  FeedbackForBi object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.courseName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.feedbackName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lang;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _feedbackForBiSerialize(
  FeedbackForBi object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.courseId);
  writer.writeString(offsets[1], object.courseName);
  writer.writeString(offsets[2], object.feedbackName);
  writer.writeLong(offsets[3], object.hq1);
  writer.writeLong(offsets[4], object.hq2);
  writer.writeLong(offsets[5], object.hq3);
  writer.writeLong(offsets[6], object.hq4);
  writer.writeString(offsets[7], object.lang);
  writer.writeString(offsets[8], object.text);
}

FeedbackForBi _feedbackForBiDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FeedbackForBi();
  object.courseId = reader.readLongOrNull(offsets[0]);
  object.courseName = reader.readStringOrNull(offsets[1]);
  object.feedbackName = reader.readStringOrNull(offsets[2]);
  object.hq1 = reader.readLongOrNull(offsets[3]);
  object.hq2 = reader.readLongOrNull(offsets[4]);
  object.hq3 = reader.readLongOrNull(offsets[5]);
  object.hq4 = reader.readLongOrNull(offsets[6]);
  object.id = id;
  object.lang = reader.readStringOrNull(offsets[7]);
  object.text = reader.readStringOrNull(offsets[8]);
  return object;
}

P _feedbackForBiDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _feedbackForBiGetId(FeedbackForBi object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _feedbackForBiGetLinks(FeedbackForBi object) {
  return [];
}

void _feedbackForBiAttach(
    IsarCollection<dynamic> col, Id id, FeedbackForBi object) {
  object.id = id;
}

extension FeedbackForBiQueryWhereSort
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QWhere> {
  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhere> anyCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'courseId'),
      );
    });
  }
}

extension FeedbackForBiQueryWhere
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QWhereClause> {
  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> idBetween(
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause>
      courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> courseIdEqualTo(
      int? courseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [courseId],
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> courseIdBetween(
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> langIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lang',
        value: [null],
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause>
      langIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lang',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> langEqualTo(
      String? lang) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lang',
        value: [lang],
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterWhereClause> langNotEqualTo(
      String? lang) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lang',
              lower: [],
              upper: [lang],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lang',
              lower: [lang],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lang',
              lower: [lang],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lang',
              lower: [],
              upper: [lang],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FeedbackForBiQueryFilter
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QFilterCondition> {
  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseName',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseName',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseName',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      courseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseName',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'feedbackName',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'feedbackName',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedbackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feedbackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feedbackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feedbackName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'feedbackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'feedbackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'feedbackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'feedbackName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedbackName',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      feedbackNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'feedbackName',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq1IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hq1',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq1IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hq1',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq1EqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hq1',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq1GreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hq1',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq1LessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hq1',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq1Between(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hq1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hq2',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hq2',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq2EqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hq2',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq2GreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hq2',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq2LessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hq2',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq2Between(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hq2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq3IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hq3',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq3IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hq3',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq3EqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hq3',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq3GreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hq3',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq3LessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hq3',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq3Between(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hq3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq4IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hq4',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq4IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hq4',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq4EqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hq4',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      hq4GreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hq4',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq4LessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hq4',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> hq4Between(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hq4',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lang',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lang',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> langEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> langBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lang',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> langMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lang',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lang',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      langIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lang',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension FeedbackForBiQueryObject
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QFilterCondition> {}

extension FeedbackForBiQueryLinks
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QFilterCondition> {}

extension FeedbackForBiQuerySortBy
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QSortBy> {
  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByCourseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseName', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      sortByCourseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseName', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      sortByFeedbackName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedbackName', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      sortByFeedbackNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedbackName', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq1', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq1', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq2', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq2', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq3', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq3', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq4() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq4', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByHq4Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq4', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension FeedbackForBiQuerySortThenBy
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QSortThenBy> {
  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByCourseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseName', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      thenByCourseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseName', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      thenByFeedbackName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedbackName', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy>
      thenByFeedbackNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedbackName', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq1', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq1', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq2', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq2', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq3', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq3', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq4() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq4', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByHq4Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hq4', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.desc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension FeedbackForBiQueryWhereDistinct
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> {
  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId');
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByCourseName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByFeedbackName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedbackName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByHq1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hq1');
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByHq2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hq2');
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByHq3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hq3');
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByHq4() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hq4');
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByLang(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lang', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeedbackForBi, FeedbackForBi, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension FeedbackForBiQueryProperty
    on QueryBuilder<FeedbackForBi, FeedbackForBi, QQueryProperty> {
  QueryBuilder<FeedbackForBi, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FeedbackForBi, int?, QQueryOperations> courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<FeedbackForBi, String?, QQueryOperations> courseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseName');
    });
  }

  QueryBuilder<FeedbackForBi, String?, QQueryOperations>
      feedbackNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedbackName');
    });
  }

  QueryBuilder<FeedbackForBi, int?, QQueryOperations> hq1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hq1');
    });
  }

  QueryBuilder<FeedbackForBi, int?, QQueryOperations> hq2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hq2');
    });
  }

  QueryBuilder<FeedbackForBi, int?, QQueryOperations> hq3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hq3');
    });
  }

  QueryBuilder<FeedbackForBi, int?, QQueryOperations> hq4Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hq4');
    });
  }

  QueryBuilder<FeedbackForBi, String?, QQueryOperations> langProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lang');
    });
  }

  QueryBuilder<FeedbackForBi, String?, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
