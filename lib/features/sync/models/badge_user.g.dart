// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_user.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBadgeUserCollection on Isar {
  IsarCollection<BadgeUser> get badgeUsers => this.collection();
}

const BadgeUserSchema = CollectionSchema(
  name: r'BadgeUser',
  id: -5285865660941822502,
  properties: {
    r'badge': PropertySchema(
      id: 0,
      name: r'badge',
      type: IsarType.string,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 2,
      name: r'email',
      type: IsarType.string,
    ),
    r'issuedOn': PropertySchema(
      id: 3,
      name: r'issuedOn',
      type: IsarType.string,
    ),
    r'issuedOnDate': PropertySchema(
      id: 4,
      name: r'issuedOnDate',
      type: IsarType.dateTime,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 5,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _badgeUserEstimateSize,
  serialize: _badgeUserSerialize,
  deserialize: _badgeUserDeserialize,
  deserializeProp: _badgeUserDeserializeProp,
  idName: r'id',
  indexes: {
    r'badge': IndexSchema(
      id: -99232107656815523,
      name: r'badge',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'badge',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'email': IndexSchema(
      id: -26095440403582047,
      name: r'email',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'email',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _badgeUserGetId,
  getLinks: _badgeUserGetLinks,
  attach: _badgeUserAttach,
  version: '3.3.2',
);

int _badgeUserEstimateSize(
  BadgeUser object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.badge;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.code;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.issuedOn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _badgeUserSerialize(
  BadgeUser object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.badge);
  writer.writeString(offsets[1], object.code);
  writer.writeString(offsets[2], object.email);
  writer.writeString(offsets[3], object.issuedOn);
  writer.writeDateTime(offsets[4], object.issuedOnDate);
  writer.writeDateTime(offsets[5], object.lastSyncedAt);
}

BadgeUser _badgeUserDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BadgeUser();
  object.badge = reader.readStringOrNull(offsets[0]);
  object.code = reader.readStringOrNull(offsets[1]);
  object.email = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.issuedOn = reader.readStringOrNull(offsets[3]);
  object.issuedOnDate = reader.readDateTimeOrNull(offsets[4]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[5]);
  return object;
}

P _badgeUserDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _badgeUserGetId(BadgeUser object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _badgeUserGetLinks(BadgeUser object) {
  return [];
}

void _badgeUserAttach(IsarCollection<dynamic> col, Id id, BadgeUser object) {
  object.id = id;
}

extension BadgeUserQueryWhereSort
    on QueryBuilder<BadgeUser, BadgeUser, QWhere> {
  QueryBuilder<BadgeUser, BadgeUser, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BadgeUserQueryWhere
    on QueryBuilder<BadgeUser, BadgeUser, QWhereClause> {
  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> idBetween(
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> badgeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'badge',
        value: [null],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> badgeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'badge',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> badgeEqualTo(
      String? badge) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'badge',
        value: [badge],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> badgeNotEqualTo(
      String? badge) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'badge',
              lower: [],
              upper: [badge],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'badge',
              lower: [badge],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'badge',
              lower: [badge],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'badge',
              lower: [],
              upper: [badge],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [null],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'code',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> codeEqualTo(
      String? code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> codeNotEqualTo(
      String? code) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'email',
        value: [null],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'email',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> emailEqualTo(
      String? email) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'email',
        value: [email],
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterWhereClause> emailNotEqualTo(
      String? email) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [],
              upper: [email],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [email],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [email],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [],
              upper: [email],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BadgeUserQueryFilter
    on QueryBuilder<BadgeUser, BadgeUser, QFilterCondition> {
  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'badge',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'badge',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badge',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badge',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badge',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badge',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> badgeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badge',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'issuedOn',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      issuedOnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'issuedOn',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issuedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'issuedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'issuedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'issuedOn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'issuedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'issuedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'issuedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'issuedOn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issuedOn',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      issuedOnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'issuedOn',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      issuedOnDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'issuedOnDate',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      issuedOnDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'issuedOnDate',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issuedOnDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      issuedOnDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'issuedOnDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      issuedOnDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'issuedOnDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> issuedOnDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'issuedOnDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> lastSyncedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition>
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

  QueryBuilder<BadgeUser, BadgeUser, QAfterFilterCondition> lastSyncedAtBetween(
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
}

extension BadgeUserQueryObject
    on QueryBuilder<BadgeUser, BadgeUser, QFilterCondition> {}

extension BadgeUserQueryLinks
    on QueryBuilder<BadgeUser, BadgeUser, QFilterCondition> {}

extension BadgeUserQuerySortBy on QueryBuilder<BadgeUser, BadgeUser, QSortBy> {
  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByBadge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badge', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByBadgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badge', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByIssuedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOn', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByIssuedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOn', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByIssuedOnDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOnDate', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByIssuedOnDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOnDate', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }
}

extension BadgeUserQuerySortThenBy
    on QueryBuilder<BadgeUser, BadgeUser, QSortThenBy> {
  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByBadge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badge', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByBadgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badge', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByIssuedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOn', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByIssuedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOn', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByIssuedOnDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOnDate', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByIssuedOnDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedOnDate', Sort.desc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QAfterSortBy> thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }
}

extension BadgeUserQueryWhereDistinct
    on QueryBuilder<BadgeUser, BadgeUser, QDistinct> {
  QueryBuilder<BadgeUser, BadgeUser, QDistinct> distinctByBadge(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badge', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QDistinct> distinctByIssuedOn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'issuedOn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QDistinct> distinctByIssuedOnDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'issuedOnDate');
    });
  }

  QueryBuilder<BadgeUser, BadgeUser, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }
}

extension BadgeUserQueryProperty
    on QueryBuilder<BadgeUser, BadgeUser, QQueryProperty> {
  QueryBuilder<BadgeUser, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BadgeUser, String?, QQueryOperations> badgeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badge');
    });
  }

  QueryBuilder<BadgeUser, String?, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<BadgeUser, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<BadgeUser, String?, QQueryOperations> issuedOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'issuedOn');
    });
  }

  QueryBuilder<BadgeUser, DateTime?, QQueryOperations> issuedOnDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'issuedOnDate');
    });
  }

  QueryBuilder<BadgeUser, DateTime?, QQueryOperations> lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }
}
