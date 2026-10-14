// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_mdl.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStatMdlCollection on Isar {
  IsarCollection<StatMdl> get statMdls => this.collection();
}

const StatMdlSchema = CollectionSchema(
  name: r'StatMdl',
  id: -4758534585800386887,
  properties: {
    r'dataCompletamento': PropertySchema(
      id: 0,
      name: r'dataCompletamento',
      type: IsarType.dateTime,
    ),
    r'dataCompletamentoCorso': PropertySchema(
      id: 1,
      name: r'dataCompletamentoCorso',
      type: IsarType.dateTime,
    ),
    r'dateOfBirth': PropertySchema(
      id: 2,
      name: r'dateOfBirth',
      type: IsarType.string,
    ),
    r'dateOfBirthCnv': PropertySchema(
      id: 3,
      name: r'dateOfBirthCnv',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 4,
      name: r'email',
      type: IsarType.string,
    ),
    r'firstname': PropertySchema(
      id: 5,
      name: r'firstname',
      type: IsarType.string,
    ),
    r'forEdition': PropertySchema(
      id: 6,
      name: r'forEdition',
      type: IsarType.string,
    ),
    r'fullName': PropertySchema(
      id: 7,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'gender': PropertySchema(
      id: 8,
      name: r'gender',
      type: IsarType.string,
    ),
    r'idCorso': PropertySchema(
      id: 9,
      name: r'idCorso',
      type: IsarType.long,
    ),
    r'idModulo': PropertySchema(
      id: 10,
      name: r'idModulo',
      type: IsarType.long,
    ),
    r'lastname': PropertySchema(
      id: 11,
      name: r'lastname',
      type: IsarType.string,
    ),
    r'membershipOrg': PropertySchema(
      id: 12,
      name: r'membershipOrg',
      type: IsarType.string,
    ),
    r'nomeAttivita': PropertySchema(
      id: 13,
      name: r'nomeAttivita',
      type: IsarType.string,
    ),
    r'nomeCorso': PropertySchema(
      id: 14,
      name: r'nomeCorso',
      type: IsarType.string,
    ),
    r'ntag': PropertySchema(
      id: 15,
      name: r'ntag',
      type: IsarType.string,
    ),
    r'partnerRef': PropertySchema(
      id: 16,
      name: r'partnerRef',
      type: IsarType.string,
    ),
    r'primoAccessoPiattaforma': PropertySchema(
      id: 17,
      name: r'primoAccessoPiattaforma',
      type: IsarType.dateTime,
    ),
    r'qualification': PropertySchema(
      id: 18,
      name: r'qualification',
      type: IsarType.string,
    ),
    r'shorthNomeCorso': PropertySchema(
      id: 19,
      name: r'shorthNomeCorso',
      type: IsarType.string,
    ),
    r'statoCompletamentoCorso': PropertySchema(
      id: 20,
      name: r'statoCompletamentoCorso',
      type: IsarType.string,
    ),
    r'tagId': PropertySchema(
      id: 21,
      name: r'tagId',
      type: IsarType.long,
    ),
    r'tipoModulo': PropertySchema(
      id: 22,
      name: r'tipoModulo',
      type: IsarType.string,
    ),
    r'ultimoAccessoPiattaforma': PropertySchema(
      id: 23,
      name: r'ultimoAccessoPiattaforma',
      type: IsarType.dateTime,
    ),
    r'userCourseLang': PropertySchema(
      id: 24,
      name: r'userCourseLang',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 25,
      name: r'userId',
      type: IsarType.long,
    ),
    r'username': PropertySchema(
      id: 26,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _statMdlEstimateSize,
  serialize: _statMdlSerialize,
  deserialize: _statMdlDeserialize,
  deserializeProp: _statMdlDeserializeProp,
  idName: r'id',
  indexes: {
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
    ),
    r'username': IndexSchema(
      id: -2899563114555695793,
      name: r'username',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'username',
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
    ),
    r'idModulo': IndexSchema(
      id: 7296029128549565391,
      name: r'idModulo',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idModulo',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'idCorso': IndexSchema(
      id: 2412203179469251964,
      name: r'idCorso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idCorso',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _statMdlGetId,
  getLinks: _statMdlGetLinks,
  attach: _statMdlAttach,
  version: '3.3.2',
);

int _statMdlEstimateSize(
  StatMdl object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dateOfBirth;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateOfBirthCnv;
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
    final value = object.firstname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.forEdition;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fullName.length * 3;
  {
    final value = object.gender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.membershipOrg;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nomeAttivita;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nomeCorso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ntag;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.partnerRef;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.qualification;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.shorthNomeCorso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.statoCompletamentoCorso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tipoModulo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userCourseLang;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.username;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _statMdlSerialize(
  StatMdl object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dataCompletamento);
  writer.writeDateTime(offsets[1], object.dataCompletamentoCorso);
  writer.writeString(offsets[2], object.dateOfBirth);
  writer.writeString(offsets[3], object.dateOfBirthCnv);
  writer.writeString(offsets[4], object.email);
  writer.writeString(offsets[5], object.firstname);
  writer.writeString(offsets[6], object.forEdition);
  writer.writeString(offsets[7], object.fullName);
  writer.writeString(offsets[8], object.gender);
  writer.writeLong(offsets[9], object.idCorso);
  writer.writeLong(offsets[10], object.idModulo);
  writer.writeString(offsets[11], object.lastname);
  writer.writeString(offsets[12], object.membershipOrg);
  writer.writeString(offsets[13], object.nomeAttivita);
  writer.writeString(offsets[14], object.nomeCorso);
  writer.writeString(offsets[15], object.ntag);
  writer.writeString(offsets[16], object.partnerRef);
  writer.writeDateTime(offsets[17], object.primoAccessoPiattaforma);
  writer.writeString(offsets[18], object.qualification);
  writer.writeString(offsets[19], object.shorthNomeCorso);
  writer.writeString(offsets[20], object.statoCompletamentoCorso);
  writer.writeLong(offsets[21], object.tagId);
  writer.writeString(offsets[22], object.tipoModulo);
  writer.writeDateTime(offsets[23], object.ultimoAccessoPiattaforma);
  writer.writeString(offsets[24], object.userCourseLang);
  writer.writeLong(offsets[25], object.userId);
  writer.writeString(offsets[26], object.username);
}

StatMdl _statMdlDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StatMdl();
  object.dataCompletamento = reader.readDateTimeOrNull(offsets[0]);
  object.dataCompletamentoCorso = reader.readDateTimeOrNull(offsets[1]);
  object.dateOfBirth = reader.readStringOrNull(offsets[2]);
  object.dateOfBirthCnv = reader.readStringOrNull(offsets[3]);
  object.email = reader.readStringOrNull(offsets[4]);
  object.firstname = reader.readStringOrNull(offsets[5]);
  object.forEdition = reader.readStringOrNull(offsets[6]);
  object.gender = reader.readStringOrNull(offsets[8]);
  object.id = id;
  object.idCorso = reader.readLongOrNull(offsets[9]);
  object.idModulo = reader.readLongOrNull(offsets[10]);
  object.lastname = reader.readStringOrNull(offsets[11]);
  object.membershipOrg = reader.readStringOrNull(offsets[12]);
  object.nomeAttivita = reader.readStringOrNull(offsets[13]);
  object.nomeCorso = reader.readStringOrNull(offsets[14]);
  object.ntag = reader.readStringOrNull(offsets[15]);
  object.partnerRef = reader.readStringOrNull(offsets[16]);
  object.primoAccessoPiattaforma = reader.readDateTimeOrNull(offsets[17]);
  object.qualification = reader.readStringOrNull(offsets[18]);
  object.shorthNomeCorso = reader.readStringOrNull(offsets[19]);
  object.statoCompletamentoCorso = reader.readStringOrNull(offsets[20]);
  object.tagId = reader.readLongOrNull(offsets[21]);
  object.tipoModulo = reader.readStringOrNull(offsets[22]);
  object.ultimoAccessoPiattaforma = reader.readDateTimeOrNull(offsets[23]);
  object.userCourseLang = reader.readStringOrNull(offsets[24]);
  object.userId = reader.readLongOrNull(offsets[25]);
  object.username = reader.readStringOrNull(offsets[26]);
  return object;
}

P _statMdlDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readLongOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _statMdlGetId(StatMdl object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _statMdlGetLinks(StatMdl object) {
  return [];
}

void _statMdlAttach(IsarCollection<dynamic> col, Id id, StatMdl object) {
  object.id = id;
}

extension StatMdlQueryWhereSort on QueryBuilder<StatMdl, StatMdl, QWhere> {
  QueryBuilder<StatMdl, StatMdl, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhere> anyIdModulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'idModulo'),
      );
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhere> anyIdCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'idCorso'),
      );
    });
  }
}

extension StatMdlQueryWhere on QueryBuilder<StatMdl, StatMdl, QWhereClause> {
  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idBetween(
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdEqualTo(int? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdNotEqualTo(
      int? userId) {
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdGreaterThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdLessThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> userIdBetween(
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'username',
        value: [null],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'username',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> usernameEqualTo(
      String? username) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'username',
        value: [username],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> usernameNotEqualTo(
      String? username) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'username',
              lower: [],
              upper: [username],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'username',
              lower: [username],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'username',
              lower: [username],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'username',
              lower: [],
              upper: [username],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'email',
        value: [null],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'email',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> emailEqualTo(
      String? email) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'email',
        value: [email],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> emailNotEqualTo(
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

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idModulo',
        value: [null],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idModulo',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloEqualTo(
      int? idModulo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idModulo',
        value: [idModulo],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloNotEqualTo(
      int? idModulo) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idModulo',
              lower: [],
              upper: [idModulo],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idModulo',
              lower: [idModulo],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idModulo',
              lower: [idModulo],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idModulo',
              lower: [],
              upper: [idModulo],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloGreaterThan(
    int? idModulo, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idModulo',
        lower: [idModulo],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloLessThan(
    int? idModulo, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idModulo',
        lower: [],
        upper: [idModulo],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idModuloBetween(
    int? lowerIdModulo,
    int? upperIdModulo, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idModulo',
        lower: [lowerIdModulo],
        includeLower: includeLower,
        upper: [upperIdModulo],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idCorso',
        value: [null],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idCorso',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoEqualTo(
      int? idCorso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idCorso',
        value: [idCorso],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoNotEqualTo(
      int? idCorso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCorso',
              lower: [],
              upper: [idCorso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCorso',
              lower: [idCorso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCorso',
              lower: [idCorso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCorso',
              lower: [],
              upper: [idCorso],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoGreaterThan(
    int? idCorso, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idCorso',
        lower: [idCorso],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoLessThan(
    int? idCorso, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idCorso',
        lower: [],
        upper: [idCorso],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterWhereClause> idCorsoBetween(
    int? lowerIdCorso,
    int? upperIdCorso, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idCorso',
        lower: [lowerIdCorso],
        includeLower: includeLower,
        upper: [upperIdCorso],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StatMdlQueryFilter
    on QueryBuilder<StatMdl, StatMdl, QFilterCondition> {
  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataCompletamento',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataCompletamento',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataCompletamento',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataCompletamento',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataCompletamento',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataCompletamento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoCorsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataCompletamentoCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoCorsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataCompletamentoCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoCorsoEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataCompletamentoCorso',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoCorsoGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataCompletamentoCorso',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoCorsoLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataCompletamentoCorso',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dataCompletamentoCorsoBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataCompletamentoCorso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOfBirth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateOfBirth',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dateOfBirthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfBirthCnv',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dateOfBirthCnvIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfBirthCnv',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirthCnv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dateOfBirthCnvGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOfBirthCnv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOfBirthCnv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOfBirthCnv',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dateOfBirthCnvStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateOfBirthCnv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateOfBirthCnv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateOfBirthCnv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> dateOfBirthCnvMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateOfBirthCnv',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dateOfBirthCnvIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirthCnv',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      dateOfBirthCnvIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOfBirthCnv',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailEqualTo(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailGreaterThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailLessThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailBetween(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailStartsWith(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailEndsWith(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailContains(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailMatches(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstname',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstname',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firstname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firstname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firstname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firstname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstname',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> firstnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firstname',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'forEdition',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'forEdition',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forEdition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forEdition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forEdition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forEdition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'forEdition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'forEdition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'forEdition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'forEdition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forEdition',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> forEditionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'forEdition',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idCorsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idCorsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idCorsoEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idCorso',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idCorsoGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idCorso',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idCorsoLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idCorso',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idCorsoBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idCorso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idModuloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idModulo',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idModuloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idModulo',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idModuloEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idModulo',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idModuloGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idModulo',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idModuloLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idModulo',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> idModuloBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idModulo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastname',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastname',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastname',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> lastnameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastname',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'membershipOrg',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      membershipOrgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'membershipOrg',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membershipOrg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      membershipOrgGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'membershipOrg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'membershipOrg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'membershipOrg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'membershipOrg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'membershipOrg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'membershipOrg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'membershipOrg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> membershipOrgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membershipOrg',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      membershipOrgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'membershipOrg',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nomeAttivita',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      nomeAttivitaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nomeAttivita',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomeAttivita',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomeAttivita',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomeAttivita',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomeAttivita',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nomeAttivita',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nomeAttivita',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nomeAttivita',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nomeAttivita',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeAttivitaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomeAttivita',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      nomeAttivitaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nomeAttivita',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nomeCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nomeCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomeCorso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nomeCorso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomeCorso',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> nomeCorsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nomeCorso',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ntag',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ntag',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ntag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ntag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ntag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ntag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ntag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ntag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ntag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ntag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ntag',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> ntagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ntag',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerRef',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerRef',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerRef',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partnerRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partnerRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerRef',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerRef',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> partnerRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerRef',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      primoAccessoPiattaformaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primoAccessoPiattaforma',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      primoAccessoPiattaformaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primoAccessoPiattaforma',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      primoAccessoPiattaformaEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primoAccessoPiattaforma',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      primoAccessoPiattaformaGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primoAccessoPiattaforma',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      primoAccessoPiattaformaLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primoAccessoPiattaforma',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      primoAccessoPiattaformaBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primoAccessoPiattaforma',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qualification',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      qualificationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qualification',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qualification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      qualificationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qualification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qualification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qualification',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qualification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qualification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qualification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qualification',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> qualificationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qualification',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      qualificationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qualification',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      shorthNomeCorsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shorthNomeCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      shorthNomeCorsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shorthNomeCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> shorthNomeCorsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shorthNomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      shorthNomeCorsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shorthNomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> shorthNomeCorsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shorthNomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> shorthNomeCorsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shorthNomeCorso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      shorthNomeCorsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shorthNomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> shorthNomeCorsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shorthNomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> shorthNomeCorsoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shorthNomeCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> shorthNomeCorsoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shorthNomeCorso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      shorthNomeCorsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shorthNomeCorso',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      shorthNomeCorsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shorthNomeCorso',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'statoCompletamentoCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'statoCompletamentoCorso',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statoCompletamentoCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statoCompletamentoCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statoCompletamentoCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statoCompletamentoCorso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statoCompletamentoCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statoCompletamentoCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statoCompletamentoCorso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statoCompletamentoCorso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statoCompletamentoCorso',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      statoCompletamentoCorsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statoCompletamentoCorso',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tagIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tagId',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tagIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tagId',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tagIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagId',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tagIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagId',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tagIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagId',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tagIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tipoModulo',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tipoModulo',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoModulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipoModulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipoModulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipoModulo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipoModulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipoModulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipoModulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipoModulo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoModulo',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> tipoModuloIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipoModulo',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      ultimoAccessoPiattaformaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ultimoAccessoPiattaforma',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      ultimoAccessoPiattaformaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ultimoAccessoPiattaforma',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      ultimoAccessoPiattaformaEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ultimoAccessoPiattaforma',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      ultimoAccessoPiattaformaGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ultimoAccessoPiattaforma',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      ultimoAccessoPiattaformaLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ultimoAccessoPiattaforma',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      ultimoAccessoPiattaformaBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ultimoAccessoPiattaforma',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userCourseLang',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      userCourseLangIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userCourseLang',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userCourseLang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      userCourseLangGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userCourseLang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userCourseLang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userCourseLang',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      userCourseLangStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userCourseLang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userCourseLang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userCourseLang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userCourseLangMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userCourseLang',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      userCourseLangIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userCourseLang',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition>
      userCourseLangIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userCourseLang',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userIdGreaterThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> userIdBetween(
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

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension StatMdlQueryObject
    on QueryBuilder<StatMdl, StatMdl, QFilterCondition> {}

extension StatMdlQueryLinks
    on QueryBuilder<StatMdl, StatMdl, QFilterCondition> {}

extension StatMdlQuerySortBy on QueryBuilder<StatMdl, StatMdl, QSortBy> {
  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDataCompletamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamento', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDataCompletamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamento', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDataCompletamentoCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamentoCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      sortByDataCompletamentoCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamentoCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDateOfBirthCnv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirthCnv', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByDateOfBirthCnvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirthCnv', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByFirstname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstname', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByFirstnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstname', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByForEdition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forEdition', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByForEditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forEdition', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByIdCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByIdCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByIdModulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idModulo', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByIdModuloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idModulo', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByLastname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastname', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByLastnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastname', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByMembershipOrg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipOrg', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByMembershipOrgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipOrg', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByNomeAttivita() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeAttivita', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByNomeAttivitaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeAttivita', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByNomeCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByNomeCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByNtag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ntag', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByNtagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ntag', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByPartnerRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerRef', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByPartnerRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerRef', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByPrimoAccessoPiattaforma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primoAccessoPiattaforma', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      sortByPrimoAccessoPiattaformaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primoAccessoPiattaforma', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByQualification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualification', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByQualificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualification', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByShorthNomeCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shorthNomeCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByShorthNomeCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shorthNomeCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByStatoCompletamentoCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statoCompletamentoCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      sortByStatoCompletamentoCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statoCompletamentoCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByTagId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagId', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByTagIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagId', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByTipoModulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoModulo', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByTipoModuloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoModulo', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      sortByUltimoAccessoPiattaforma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimoAccessoPiattaforma', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      sortByUltimoAccessoPiattaformaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimoAccessoPiattaforma', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByUserCourseLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userCourseLang', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByUserCourseLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userCourseLang', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension StatMdlQuerySortThenBy
    on QueryBuilder<StatMdl, StatMdl, QSortThenBy> {
  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDataCompletamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamento', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDataCompletamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamento', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDataCompletamentoCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamentoCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      thenByDataCompletamentoCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCompletamentoCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDateOfBirthCnv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirthCnv', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByDateOfBirthCnvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirthCnv', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByFirstname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstname', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByFirstnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstname', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByForEdition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forEdition', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByForEditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forEdition', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByIdCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByIdCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByIdModulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idModulo', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByIdModuloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idModulo', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByLastname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastname', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByLastnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastname', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByMembershipOrg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipOrg', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByMembershipOrgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipOrg', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByNomeAttivita() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeAttivita', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByNomeAttivitaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeAttivita', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByNomeCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByNomeCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomeCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByNtag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ntag', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByNtagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ntag', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByPartnerRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerRef', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByPartnerRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerRef', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByPrimoAccessoPiattaforma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primoAccessoPiattaforma', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      thenByPrimoAccessoPiattaformaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primoAccessoPiattaforma', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByQualification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualification', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByQualificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualification', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByShorthNomeCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shorthNomeCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByShorthNomeCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shorthNomeCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByStatoCompletamentoCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statoCompletamentoCorso', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      thenByStatoCompletamentoCorsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statoCompletamentoCorso', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByTagId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagId', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByTagIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagId', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByTipoModulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoModulo', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByTipoModuloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoModulo', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      thenByUltimoAccessoPiattaforma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimoAccessoPiattaforma', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy>
      thenByUltimoAccessoPiattaformaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimoAccessoPiattaforma', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByUserCourseLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userCourseLang', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByUserCourseLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userCourseLang', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension StatMdlQueryWhereDistinct
    on QueryBuilder<StatMdl, StatMdl, QDistinct> {
  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByDataCompletamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataCompletamento');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByDataCompletamentoCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataCompletamentoCorso');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByDateOfBirth(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfBirth', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByDateOfBirthCnv(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfBirthCnv',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByFirstname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByForEdition(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forEdition', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByIdCorso() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idCorso');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByIdModulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idModulo');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByLastname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByMembershipOrg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'membershipOrg',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByNomeAttivita(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomeAttivita', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByNomeCorso(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomeCorso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByNtag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ntag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByPartnerRef(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct>
      distinctByPrimoAccessoPiattaforma() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primoAccessoPiattaforma');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByQualification(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qualification',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByShorthNomeCorso(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shorthNomeCorso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByStatoCompletamentoCorso(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statoCompletamentoCorso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByTagId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagId');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByTipoModulo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipoModulo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct>
      distinctByUltimoAccessoPiattaforma() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ultimoAccessoPiattaforma');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByUserCourseLang(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userCourseLang',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<StatMdl, StatMdl, QDistinct> distinctByUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension StatMdlQueryProperty
    on QueryBuilder<StatMdl, StatMdl, QQueryProperty> {
  QueryBuilder<StatMdl, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StatMdl, DateTime?, QQueryOperations>
      dataCompletamentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataCompletamento');
    });
  }

  QueryBuilder<StatMdl, DateTime?, QQueryOperations>
      dataCompletamentoCorsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataCompletamentoCorso');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> dateOfBirthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfBirth');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> dateOfBirthCnvProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfBirthCnv');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> firstnameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstname');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> forEditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forEdition');
    });
  }

  QueryBuilder<StatMdl, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<StatMdl, int?, QQueryOperations> idCorsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idCorso');
    });
  }

  QueryBuilder<StatMdl, int?, QQueryOperations> idModuloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idModulo');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> lastnameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastname');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> membershipOrgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'membershipOrg');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> nomeAttivitaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomeAttivita');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> nomeCorsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomeCorso');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> ntagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ntag');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> partnerRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerRef');
    });
  }

  QueryBuilder<StatMdl, DateTime?, QQueryOperations>
      primoAccessoPiattaformaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primoAccessoPiattaforma');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> qualificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qualification');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> shorthNomeCorsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shorthNomeCorso');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations>
      statoCompletamentoCorsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statoCompletamentoCorso');
    });
  }

  QueryBuilder<StatMdl, int?, QQueryOperations> tagIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagId');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> tipoModuloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipoModulo');
    });
  }

  QueryBuilder<StatMdl, DateTime?, QQueryOperations>
      ultimoAccessoPiattaformaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ultimoAccessoPiattaforma');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> userCourseLangProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userCourseLang');
    });
  }

  QueryBuilder<StatMdl, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<StatMdl, String?, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
