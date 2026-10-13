// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCourseCollection on Isar {
  IsarCollection<Course> get courses => this.collection();
}

const CourseSchema = CollectionSchema(
  name: r'Course',
  id: -5832084671214696602,
  properties: {
    r'categoryid': PropertySchema(
      id: 0,
      name: r'categoryid',
      type: IsarType.long,
    ),
    r'categorysortorder': PropertySchema(
      id: 1,
      name: r'categorysortorder',
      type: IsarType.long,
    ),
    r'completionnotify': PropertySchema(
      id: 2,
      name: r'completionnotify',
      type: IsarType.long,
    ),
    r'courseformatoptions': PropertySchema(
      id: 3,
      name: r'courseformatoptions',
      type: IsarType.objectList,
      target: r'CourseFormatOption',
    ),
    r'customfields': PropertySchema(
      id: 4,
      name: r'customfields',
      type: IsarType.objectList,
      target: r'CourseCustomField',
    ),
    r'defaultgroupingid': PropertySchema(
      id: 5,
      name: r'defaultgroupingid',
      type: IsarType.long,
    ),
    r'displayname': PropertySchema(
      id: 6,
      name: r'displayname',
      type: IsarType.string,
    ),
    r'enablecompletion': PropertySchema(
      id: 7,
      name: r'enablecompletion',
      type: IsarType.long,
    ),
    r'endDateTime': PropertySchema(
      id: 8,
      name: r'endDateTime',
      type: IsarType.dateTime,
    ),
    r'enddate': PropertySchema(
      id: 9,
      name: r'enddate',
      type: IsarType.long,
    ),
    r'forcetheme': PropertySchema(
      id: 10,
      name: r'forcetheme',
      type: IsarType.string,
    ),
    r'format': PropertySchema(
      id: 11,
      name: r'format',
      type: IsarType.string,
    ),
    r'fullname': PropertySchema(
      id: 12,
      name: r'fullname',
      type: IsarType.string,
    ),
    r'groupmode': PropertySchema(
      id: 13,
      name: r'groupmode',
      type: IsarType.long,
    ),
    r'groupmodeforce': PropertySchema(
      id: 14,
      name: r'groupmodeforce',
      type: IsarType.long,
    ),
    r'idnumber': PropertySchema(
      id: 15,
      name: r'idnumber',
      type: IsarType.string,
    ),
    r'lang': PropertySchema(
      id: 16,
      name: r'lang',
      type: IsarType.string,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 17,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'maxbytes': PropertySchema(
      id: 18,
      name: r'maxbytes',
      type: IsarType.long,
    ),
    r'newsitems': PropertySchema(
      id: 19,
      name: r'newsitems',
      type: IsarType.long,
    ),
    r'numsections': PropertySchema(
      id: 20,
      name: r'numsections',
      type: IsarType.long,
    ),
    r'shortname': PropertySchema(
      id: 21,
      name: r'shortname',
      type: IsarType.string,
    ),
    r'showactivitydates': PropertySchema(
      id: 22,
      name: r'showactivitydates',
      type: IsarType.bool,
    ),
    r'showcompletionconditions': PropertySchema(
      id: 23,
      name: r'showcompletionconditions',
      type: IsarType.bool,
    ),
    r'showgrades': PropertySchema(
      id: 24,
      name: r'showgrades',
      type: IsarType.long,
    ),
    r'showreports': PropertySchema(
      id: 25,
      name: r'showreports',
      type: IsarType.long,
    ),
    r'startDateTime': PropertySchema(
      id: 26,
      name: r'startDateTime',
      type: IsarType.dateTime,
    ),
    r'startdate': PropertySchema(
      id: 27,
      name: r'startdate',
      type: IsarType.long,
    ),
    r'summary': PropertySchema(
      id: 28,
      name: r'summary',
      type: IsarType.string,
    ),
    r'summaryformat': PropertySchema(
      id: 29,
      name: r'summaryformat',
      type: IsarType.long,
    ),
    r'timecreated': PropertySchema(
      id: 30,
      name: r'timecreated',
      type: IsarType.long,
    ),
    r'timecreatedDate': PropertySchema(
      id: 31,
      name: r'timecreatedDate',
      type: IsarType.dateTime,
    ),
    r'timemodified': PropertySchema(
      id: 32,
      name: r'timemodified',
      type: IsarType.long,
    ),
    r'timemodifiedDate': PropertySchema(
      id: 33,
      name: r'timemodifiedDate',
      type: IsarType.dateTime,
    ),
    r'visible': PropertySchema(
      id: 34,
      name: r'visible',
      type: IsarType.long,
    )
  },
  estimateSize: _courseEstimateSize,
  serialize: _courseSerialize,
  deserialize: _courseDeserialize,
  deserializeProp: _courseDeserializeProp,
  idName: r'id',
  indexes: {
    r'shortname': IndexSchema(
      id: 8571077326306730063,
      name: r'shortname',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'shortname',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'categoryid': IndexSchema(
      id: -6801770887808600456,
      name: r'categoryid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryid',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'fullname': IndexSchema(
      id: 7846820049795454093,
      name: r'fullname',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'fullname',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idnumber': IndexSchema(
      id: 4130746106583082196,
      name: r'idnumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idnumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'CourseFormatOption': CourseFormatOptionSchema,
    r'CourseCustomField': CourseCustomFieldSchema
  },
  getId: _courseGetId,
  getLinks: _courseGetLinks,
  attach: _courseAttach,
  version: '3.3.2',
);

int _courseEstimateSize(
  Course object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.courseformatoptions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[CourseFormatOption]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              CourseFormatOptionSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.customfields;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[CourseCustomField]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              CourseCustomFieldSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.displayname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.forcetheme;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.format;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fullname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.idnumber;
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
    final value = object.shortname;
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

void _courseSerialize(
  Course object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryid);
  writer.writeLong(offsets[1], object.categorysortorder);
  writer.writeLong(offsets[2], object.completionnotify);
  writer.writeObjectList<CourseFormatOption>(
    offsets[3],
    allOffsets,
    CourseFormatOptionSchema.serialize,
    object.courseformatoptions,
  );
  writer.writeObjectList<CourseCustomField>(
    offsets[4],
    allOffsets,
    CourseCustomFieldSchema.serialize,
    object.customfields,
  );
  writer.writeLong(offsets[5], object.defaultgroupingid);
  writer.writeString(offsets[6], object.displayname);
  writer.writeLong(offsets[7], object.enablecompletion);
  writer.writeDateTime(offsets[8], object.endDateTime);
  writer.writeLong(offsets[9], object.enddate);
  writer.writeString(offsets[10], object.forcetheme);
  writer.writeString(offsets[11], object.format);
  writer.writeString(offsets[12], object.fullname);
  writer.writeLong(offsets[13], object.groupmode);
  writer.writeLong(offsets[14], object.groupmodeforce);
  writer.writeString(offsets[15], object.idnumber);
  writer.writeString(offsets[16], object.lang);
  writer.writeDateTime(offsets[17], object.lastSyncedAt);
  writer.writeLong(offsets[18], object.maxbytes);
  writer.writeLong(offsets[19], object.newsitems);
  writer.writeLong(offsets[20], object.numsections);
  writer.writeString(offsets[21], object.shortname);
  writer.writeBool(offsets[22], object.showactivitydates);
  writer.writeBool(offsets[23], object.showcompletionconditions);
  writer.writeLong(offsets[24], object.showgrades);
  writer.writeLong(offsets[25], object.showreports);
  writer.writeDateTime(offsets[26], object.startDateTime);
  writer.writeLong(offsets[27], object.startdate);
  writer.writeString(offsets[28], object.summary);
  writer.writeLong(offsets[29], object.summaryformat);
  writer.writeLong(offsets[30], object.timecreated);
  writer.writeDateTime(offsets[31], object.timecreatedDate);
  writer.writeLong(offsets[32], object.timemodified);
  writer.writeDateTime(offsets[33], object.timemodifiedDate);
  writer.writeLong(offsets[34], object.visible);
}

Course _courseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Course();
  object.categoryid = reader.readLongOrNull(offsets[0]);
  object.categorysortorder = reader.readLongOrNull(offsets[1]);
  object.completionnotify = reader.readLongOrNull(offsets[2]);
  object.courseformatoptions = reader.readObjectList<CourseFormatOption>(
    offsets[3],
    CourseFormatOptionSchema.deserialize,
    allOffsets,
    CourseFormatOption(),
  );
  object.customfields = reader.readObjectList<CourseCustomField>(
    offsets[4],
    CourseCustomFieldSchema.deserialize,
    allOffsets,
    CourseCustomField(),
  );
  object.defaultgroupingid = reader.readLongOrNull(offsets[5]);
  object.displayname = reader.readStringOrNull(offsets[6]);
  object.enablecompletion = reader.readLongOrNull(offsets[7]);
  object.endDateTime = reader.readDateTimeOrNull(offsets[8]);
  object.enddate = reader.readLongOrNull(offsets[9]);
  object.forcetheme = reader.readStringOrNull(offsets[10]);
  object.format = reader.readStringOrNull(offsets[11]);
  object.fullname = reader.readStringOrNull(offsets[12]);
  object.groupmode = reader.readLongOrNull(offsets[13]);
  object.groupmodeforce = reader.readLongOrNull(offsets[14]);
  object.id = id;
  object.idnumber = reader.readStringOrNull(offsets[15]);
  object.lang = reader.readStringOrNull(offsets[16]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[17]);
  object.maxbytes = reader.readLongOrNull(offsets[18]);
  object.newsitems = reader.readLongOrNull(offsets[19]);
  object.numsections = reader.readLongOrNull(offsets[20]);
  object.shortname = reader.readStringOrNull(offsets[21]);
  object.showactivitydates = reader.readBoolOrNull(offsets[22]);
  object.showcompletionconditions = reader.readBoolOrNull(offsets[23]);
  object.showgrades = reader.readLongOrNull(offsets[24]);
  object.showreports = reader.readLongOrNull(offsets[25]);
  object.startDateTime = reader.readDateTimeOrNull(offsets[26]);
  object.startdate = reader.readLongOrNull(offsets[27]);
  object.summary = reader.readStringOrNull(offsets[28]);
  object.summaryformat = reader.readLongOrNull(offsets[29]);
  object.timecreated = reader.readLongOrNull(offsets[30]);
  object.timecreatedDate = reader.readDateTimeOrNull(offsets[31]);
  object.timemodified = reader.readLongOrNull(offsets[32]);
  object.timemodifiedDate = reader.readDateTimeOrNull(offsets[33]);
  object.visible = reader.readLongOrNull(offsets[34]);
  return object;
}

P _courseDeserializeProp<P>(
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
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<CourseFormatOption>(
        offset,
        CourseFormatOptionSchema.deserialize,
        allOffsets,
        CourseFormatOption(),
      )) as P;
    case 4:
      return (reader.readObjectList<CourseCustomField>(
        offset,
        CourseCustomFieldSchema.deserialize,
        allOffsets,
        CourseCustomField(),
      )) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readLongOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readLongOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readBoolOrNull(offset)) as P;
    case 23:
      return (reader.readBoolOrNull(offset)) as P;
    case 24:
      return (reader.readLongOrNull(offset)) as P;
    case 25:
      return (reader.readLongOrNull(offset)) as P;
    case 26:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 27:
      return (reader.readLongOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readLongOrNull(offset)) as P;
    case 30:
      return (reader.readLongOrNull(offset)) as P;
    case 31:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 32:
      return (reader.readLongOrNull(offset)) as P;
    case 33:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 34:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _courseGetId(Course object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _courseGetLinks(Course object) {
  return [];
}

void _courseAttach(IsarCollection<dynamic> col, Id id, Course object) {
  object.id = id;
}

extension CourseQueryWhereSort on QueryBuilder<Course, Course, QWhere> {
  QueryBuilder<Course, Course, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Course, Course, QAfterWhere> anyCategoryid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'categoryid'),
      );
    });
  }
}

extension CourseQueryWhere on QueryBuilder<Course, Course, QWhereClause> {
  QueryBuilder<Course, Course, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Course, Course, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idBetween(
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

  QueryBuilder<Course, Course, QAfterWhereClause> shortnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shortname',
        value: [null],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> shortnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'shortname',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> shortnameEqualTo(
      String? shortname) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shortname',
        value: [shortname],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> shortnameNotEqualTo(
      String? shortname) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shortname',
              lower: [],
              upper: [shortname],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shortname',
              lower: [shortname],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shortname',
              lower: [shortname],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shortname',
              lower: [],
              upper: [shortname],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryid',
        value: [null],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryid',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidEqualTo(
      int? categoryid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryid',
        value: [categoryid],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidNotEqualTo(
      int? categoryid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryid',
              lower: [],
              upper: [categoryid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryid',
              lower: [categoryid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryid',
              lower: [categoryid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryid',
              lower: [],
              upper: [categoryid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidGreaterThan(
    int? categoryid, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryid',
        lower: [categoryid],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidLessThan(
    int? categoryid, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryid',
        lower: [],
        upper: [categoryid],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> categoryidBetween(
    int? lowerCategoryid,
    int? upperCategoryid, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryid',
        lower: [lowerCategoryid],
        includeLower: includeLower,
        upper: [upperCategoryid],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> fullnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fullname',
        value: [null],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> fullnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fullname',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> fullnameEqualTo(
      String? fullname) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fullname',
        value: [fullname],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> fullnameNotEqualTo(
      String? fullname) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fullname',
              lower: [],
              upper: [fullname],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fullname',
              lower: [fullname],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fullname',
              lower: [fullname],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fullname',
              lower: [],
              upper: [fullname],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idnumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idnumber',
        value: [null],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idnumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idnumber',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idnumberEqualTo(
      String? idnumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idnumber',
        value: [idnumber],
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idnumberNotEqualTo(
      String? idnumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idnumber',
              lower: [],
              upper: [idnumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idnumber',
              lower: [idnumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idnumber',
              lower: [idnumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idnumber',
              lower: [],
              upper: [idnumber],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CourseQueryFilter on QueryBuilder<Course, Course, QFilterCondition> {
  QueryBuilder<Course, Course, QAfterFilterCondition> categoryidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryid',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categoryidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryid',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categoryidEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryid',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categoryidGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryid',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categoryidLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryid',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categoryidBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      categorysortorderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categorysortorder',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      categorysortorderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categorysortorder',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categorysortorderEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categorysortorder',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      categorysortorderGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categorysortorder',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categorysortorderLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categorysortorder',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> categorysortorderBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categorysortorder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> completionnotifyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completionnotify',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      completionnotifyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completionnotify',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> completionnotifyEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionnotify',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      completionnotifyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionnotify',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> completionnotifyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionnotify',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> completionnotifyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionnotify',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseformatoptions',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseformatoptions',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courseformatoptions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courseformatoptions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courseformatoptions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courseformatoptions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courseformatoptions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courseformatoptions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customfields',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customfields',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customfields',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customfields',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customfields',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      customfieldsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customfields',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      customfieldsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customfields',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customfields',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      defaultgroupingidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultgroupingid',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      defaultgroupingidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultgroupingid',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> defaultgroupingidEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultgroupingid',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      defaultgroupingidGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultgroupingid',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> defaultgroupingidLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultgroupingid',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> defaultgroupingidBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultgroupingid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'displayname',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'displayname',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayname',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> displaynameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayname',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enablecompletionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'enablecompletion',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      enablecompletionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'enablecompletion',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enablecompletionEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enablecompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      enablecompletionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enablecompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enablecompletionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enablecompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enablecompletionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enablecompletion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> endDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDateTime',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> endDateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDateTime',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> endDateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> endDateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> endDateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> endDateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enddateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'enddate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enddateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'enddate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enddateEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enddate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enddateGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enddate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enddateLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enddate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> enddateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enddate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'forcetheme',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'forcetheme',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forcetheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forcetheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forcetheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forcetheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'forcetheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'forcetheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'forcetheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'forcetheme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forcetheme',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> forcethemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'forcetheme',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'format',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'format',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'format',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'format',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'format',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> formatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'format',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullname',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullname',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullname',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> fullnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullname',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupmode',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupmode',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupmode',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeforceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupmodeforce',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      groupmodeforceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupmodeforce',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeforceEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupmodeforce',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeforceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupmodeforce',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeforceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupmodeforce',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> groupmodeforceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupmodeforce',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idnumber',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idnumber',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idnumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idnumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idnumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idnumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idnumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idnumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idnumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idnumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idnumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idnumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idnumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> langIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lang',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> langIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lang',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> langEqualTo(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langStartsWith(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langEndsWith(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> langMatches(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> langIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lang',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> langIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lang',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastSyncedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastSyncedAtGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> lastSyncedAtLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> lastSyncedAtBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> maxbytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxbytes',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> maxbytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxbytes',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> maxbytesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxbytes',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> maxbytesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxbytes',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> maxbytesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxbytes',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> maxbytesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxbytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> newsitemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'newsitems',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> newsitemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'newsitems',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> newsitemsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newsitems',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> newsitemsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'newsitems',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> newsitemsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'newsitems',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> newsitemsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'newsitems',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> numsectionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numsections',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> numsectionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numsections',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> numsectionsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numsections',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> numsectionsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numsections',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> numsectionsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numsections',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> numsectionsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numsections',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shortname',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shortname',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shortname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shortname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortname',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> shortnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shortname',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      showactivitydatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'showactivitydates',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      showactivitydatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'showactivitydates',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showactivitydatesEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showactivitydates',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      showcompletionconditionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'showcompletionconditions',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      showcompletionconditionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'showcompletionconditions',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      showcompletionconditionsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showcompletionconditions',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showgradesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'showgrades',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showgradesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'showgrades',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showgradesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showgrades',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showgradesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'showgrades',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showgradesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'showgrades',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showgradesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'showgrades',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showreportsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'showreports',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showreportsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'showreports',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showreportsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showreports',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showreportsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'showreports',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showreportsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'showreports',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> showreportsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'showreports',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDateTime',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startDateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDateTime',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startDateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startDateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startDateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startDateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startdateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startdate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startdateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startdate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startdateEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startdate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startdateGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startdate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startdateLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startdate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> startdateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startdate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryEqualTo(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryStartsWith(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryEndsWith(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryContains(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryMatches(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryformatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'summaryformat',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryformatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'summaryformat',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryformatEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryformat',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryformatGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryformatLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> summaryformatBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timecreated',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timecreated',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timecreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timecreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timecreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timecreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timecreatedDate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      timecreatedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timecreatedDate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timecreatedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      timecreatedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timecreatedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timecreatedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timecreatedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timecreatedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timemodified',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timemodified',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timemodified',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timemodified',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timemodified',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timemodified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timemodifiedDate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      timemodifiedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timemodifiedDate',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timemodifiedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      timemodifiedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timemodifiedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timemodifiedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> timemodifiedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timemodifiedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> visibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'visible',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> visibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'visible',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> visibleEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visible',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> visibleGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> visibleLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> visibleBetween(
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

extension CourseQueryObject on QueryBuilder<Course, Course, QFilterCondition> {
  QueryBuilder<Course, Course, QAfterFilterCondition>
      courseformatoptionsElement(FilterQuery<CourseFormatOption> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'courseformatoptions');
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> customfieldsElement(
      FilterQuery<CourseCustomField> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'customfields');
    });
  }
}

extension CourseQueryLinks on QueryBuilder<Course, Course, QFilterCondition> {}

extension CourseQuerySortBy on QueryBuilder<Course, Course, QSortBy> {
  QueryBuilder<Course, Course, QAfterSortBy> sortByCategoryid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryid', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByCategoryidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryid', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByCategorysortorder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorysortorder', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByCategorysortorderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorysortorder', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByCompletionnotify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionnotify', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByCompletionnotifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionnotify', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByDefaultgroupingid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultgroupingid', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByDefaultgroupingidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultgroupingid', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByDisplayname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayname', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByDisplaynameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayname', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByEnablecompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablecompletion', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByEnablecompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablecompletion', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByEndDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByEndDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByEnddate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enddate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByEnddateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enddate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByForcetheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forcetheme', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByForcethemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forcetheme', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByFullname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullname', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByFullnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullname', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByGroupmode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmode', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByGroupmodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmode', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByGroupmodeforce() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmodeforce', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByGroupmodeforceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmodeforce', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByIdnumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idnumber', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByIdnumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idnumber', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByMaxbytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxbytes', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByMaxbytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxbytes', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByNewsitems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newsitems', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByNewsitemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newsitems', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByNumsections() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numsections', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByNumsectionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numsections', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShortname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortname', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShortnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortname', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowactivitydates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showactivitydates', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowactivitydatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showactivitydates', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowcompletionconditions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showcompletionconditions', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy>
      sortByShowcompletionconditionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showcompletionconditions', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowgrades() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showgrades', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowgradesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showgrades', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowreports() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showreports', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByShowreportsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showreports', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByStartDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByStartDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByStartdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startdate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByStartdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startdate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortBySummaryformat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortBySummaryformatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimecreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreated', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimecreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreated', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimecreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreatedDate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimecreatedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreatedDate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimemodified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodified', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimemodifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodified', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimemodifiedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodifiedDate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByTimemodifiedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodifiedDate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByVisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByVisibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.desc);
    });
  }
}

extension CourseQuerySortThenBy on QueryBuilder<Course, Course, QSortThenBy> {
  QueryBuilder<Course, Course, QAfterSortBy> thenByCategoryid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryid', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByCategoryidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryid', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByCategorysortorder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorysortorder', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByCategorysortorderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorysortorder', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByCompletionnotify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionnotify', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByCompletionnotifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionnotify', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByDefaultgroupingid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultgroupingid', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByDefaultgroupingidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultgroupingid', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByDisplayname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayname', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByDisplaynameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayname', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByEnablecompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablecompletion', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByEnablecompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enablecompletion', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByEndDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByEndDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByEnddate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enddate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByEnddateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enddate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByForcetheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forcetheme', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByForcethemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forcetheme', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByFullname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullname', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByFullnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullname', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByGroupmode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmode', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByGroupmodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmode', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByGroupmodeforce() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmodeforce', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByGroupmodeforceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupmodeforce', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByIdnumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idnumber', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByIdnumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idnumber', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByMaxbytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxbytes', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByMaxbytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxbytes', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByNewsitems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newsitems', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByNewsitemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newsitems', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByNumsections() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numsections', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByNumsectionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numsections', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShortname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortname', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShortnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortname', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowactivitydates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showactivitydates', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowactivitydatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showactivitydates', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowcompletionconditions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showcompletionconditions', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy>
      thenByShowcompletionconditionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showcompletionconditions', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowgrades() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showgrades', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowgradesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showgrades', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowreports() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showreports', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByShowreportsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showreports', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByStartDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByStartDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByStartdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startdate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByStartdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startdate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenBySummaryformat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenBySummaryformatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryformat', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimecreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreated', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimecreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreated', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimecreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreatedDate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimecreatedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timecreatedDate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimemodified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodified', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimemodifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodified', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimemodifiedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodifiedDate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByTimemodifiedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timemodifiedDate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByVisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByVisibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visible', Sort.desc);
    });
  }
}

extension CourseQueryWhereDistinct on QueryBuilder<Course, Course, QDistinct> {
  QueryBuilder<Course, Course, QDistinct> distinctByCategoryid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryid');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByCategorysortorder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categorysortorder');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByCompletionnotify() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionnotify');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByDefaultgroupingid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultgroupingid');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByDisplayname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByEnablecompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enablecompletion');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByEndDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDateTime');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByEnddate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enddate');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByForcetheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forcetheme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByFormat(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'format', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByFullname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByGroupmode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupmode');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByGroupmodeforce() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupmodeforce');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByIdnumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idnumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByLang(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lang', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByMaxbytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxbytes');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByNewsitems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'newsitems');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByNumsections() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numsections');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByShortname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shortname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByShowactivitydates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showactivitydates');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByShowcompletionconditions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showcompletionconditions');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByShowgrades() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showgrades');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByShowreports() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showreports');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByStartDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDateTime');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByStartdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startdate');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctBySummaryformat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summaryformat');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByTimecreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timecreated');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByTimecreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timecreatedDate');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByTimemodified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timemodified');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByTimemodifiedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timemodifiedDate');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByVisible() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visible');
    });
  }
}

extension CourseQueryProperty on QueryBuilder<Course, Course, QQueryProperty> {
  QueryBuilder<Course, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> categoryidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryid');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> categorysortorderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categorysortorder');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> completionnotifyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionnotify');
    });
  }

  QueryBuilder<Course, List<CourseFormatOption>?, QQueryOperations>
      courseformatoptionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseformatoptions');
    });
  }

  QueryBuilder<Course, List<CourseCustomField>?, QQueryOperations>
      customfieldsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customfields');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> defaultgroupingidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultgroupingid');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> displaynameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayname');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> enablecompletionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enablecompletion');
    });
  }

  QueryBuilder<Course, DateTime?, QQueryOperations> endDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDateTime');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> enddateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enddate');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> forcethemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forcetheme');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> formatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'format');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> fullnameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullname');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> groupmodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupmode');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> groupmodeforceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupmodeforce');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> idnumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idnumber');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> langProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lang');
    });
  }

  QueryBuilder<Course, DateTime?, QQueryOperations> lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> maxbytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxbytes');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> newsitemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'newsitems');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> numsectionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numsections');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> shortnameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shortname');
    });
  }

  QueryBuilder<Course, bool?, QQueryOperations> showactivitydatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showactivitydates');
    });
  }

  QueryBuilder<Course, bool?, QQueryOperations>
      showcompletionconditionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showcompletionconditions');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> showgradesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showgrades');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> showreportsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showreports');
    });
  }

  QueryBuilder<Course, DateTime?, QQueryOperations> startDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDateTime');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> startdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startdate');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> summaryformatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summaryformat');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> timecreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timecreated');
    });
  }

  QueryBuilder<Course, DateTime?, QQueryOperations> timecreatedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timecreatedDate');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> timemodifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timemodified');
    });
  }

  QueryBuilder<Course, DateTime?, QQueryOperations> timemodifiedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timemodifiedDate');
    });
  }

  QueryBuilder<Course, int?, QQueryOperations> visibleProperty() {
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

const CourseFormatOptionSchema = Schema(
  name: r'CourseFormatOption',
  id: -5475029049653032678,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.long,
    )
  },
  estimateSize: _courseFormatOptionEstimateSize,
  serialize: _courseFormatOptionSerialize,
  deserialize: _courseFormatOptionDeserialize,
  deserializeProp: _courseFormatOptionDeserializeProp,
);

int _courseFormatOptionEstimateSize(
  CourseFormatOption object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _courseFormatOptionSerialize(
  CourseFormatOption object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeLong(offsets[1], object.value);
}

CourseFormatOption _courseFormatOptionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CourseFormatOption();
  object.name = reader.readStringOrNull(offsets[0]);
  object.value = reader.readLongOrNull(offsets[1]);
  return object;
}

P _courseFormatOptionDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CourseFormatOptionQueryFilter
    on QueryBuilder<CourseFormatOption, CourseFormatOption, QFilterCondition> {
  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
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

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
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

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      valueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      valueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      valueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseFormatOption, CourseFormatOption, QAfterFilterCondition>
      valueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CourseFormatOptionQueryObject
    on QueryBuilder<CourseFormatOption, CourseFormatOption, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CourseCustomFieldSchema = Schema(
  name: r'CourseCustomField',
  id: 1124148033255067355,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'shortname': PropertySchema(
      id: 1,
      name: r'shortname',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 2,
      name: r'type',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 3,
      name: r'value',
      type: IsarType.string,
    ),
    r'valueraw': PropertySchema(
      id: 4,
      name: r'valueraw',
      type: IsarType.string,
    )
  },
  estimateSize: _courseCustomFieldEstimateSize,
  serialize: _courseCustomFieldSerialize,
  deserialize: _courseCustomFieldDeserialize,
  deserializeProp: _courseCustomFieldDeserializeProp,
);

int _courseCustomFieldEstimateSize(
  CourseCustomField object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.shortname;
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
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.valueraw;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _courseCustomFieldSerialize(
  CourseCustomField object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeString(offsets[1], object.shortname);
  writer.writeString(offsets[2], object.type);
  writer.writeString(offsets[3], object.value);
  writer.writeString(offsets[4], object.valueraw);
}

CourseCustomField _courseCustomFieldDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CourseCustomField();
  object.name = reader.readStringOrNull(offsets[0]);
  object.shortname = reader.readStringOrNull(offsets[1]);
  object.type = reader.readStringOrNull(offsets[2]);
  object.value = reader.readStringOrNull(offsets[3]);
  object.valueraw = reader.readStringOrNull(offsets[4]);
  return object;
}

P _courseCustomFieldDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CourseCustomFieldQueryFilter
    on QueryBuilder<CourseCustomField, CourseCustomField, QFilterCondition> {
  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shortname',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shortname',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shortname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shortname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shortname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortname',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      shortnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shortname',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeEqualTo(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeGreaterThan(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeLessThan(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeBetween(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeStartsWith(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeEndsWith(
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

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'valueraw',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'valueraw',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valueraw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valueraw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valueraw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valueraw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'valueraw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'valueraw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'valueraw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'valueraw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valueraw',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseCustomField, CourseCustomField, QAfterFilterCondition>
      valuerawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'valueraw',
        value: '',
      ));
    });
  }
}

extension CourseCustomFieldQueryObject
    on QueryBuilder<CourseCustomField, CourseCustomField, QFilterCondition> {}
