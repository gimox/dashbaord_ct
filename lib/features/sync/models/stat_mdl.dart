import 'package:isar_community/isar.dart';

part 'stat_mdl.g.dart';

@collection
class StatMdl {
  Id id = Isar.autoIncrement;

  @Index()
  int? userId;

  @Index()
  String? username;

  String? firstname;
  String? lastname;

  @Index()
  String? email;

  String? statoCompletamentoCorso;
  DateTime? dataCompletamentoCorso;
  DateTime? primoAccessoPiattaforma;
  DateTime? ultimoAccessoPiattaforma;
  String? forEdition;
  String? gender;
  String? dateOfBirth;
  String? dateOfBirthCnv;
  String? userCourseLang;
  String? qualification;
  String? membershipOrg;
  String? partnerRef;
  String? tipoModulo;

  @Index()
  int? idModulo;

  @Index()
  int? idCorso;

  String? shorthNomeCorso;
  String? nomeCorso;
  int? tagId;
  String? ntag;
  String? nomeAttivita;
  DateTime? dataCompletamento;

  String get fullName => '${firstname ?? ''} ${lastname ?? ''}'.trim();

  StatMdl();

  factory StatMdl.fromJson(Map<String, dynamic> json) {
    final model = StatMdl();
    model.userId = _parseInt(json['id']);
    model.username = json['username']?.toString();
    model.firstname = json['firstname']?.toString();
    model.lastname = json['lastname']?.toString();
    model.email = json['email']?.toString();
    model.statoCompletamentoCorso = json['stato_completamento_corso']?.toString();
    model.dataCompletamentoCorso = _parseDate(json['data_completamento_corso']);
    model.primoAccessoPiattaforma = _parseDate(json['primo_accesso_piattaforma']);
    model.ultimoAccessoPiattaforma = _parseDate(json['ultimo_accesso_piattaforma']);
    model.forEdition = json['for_edition']?.toString();
    model.gender = json['gender']?.toString();
    model.dateOfBirth = json['date_of_birth']?.toString();
    model.dateOfBirthCnv = json['date_of_birth_cnv']?.toString();
    model.userCourseLang = json['user_course_lang']?.toString();
    model.qualification = json['qualification']?.toString();
    model.membershipOrg = json['membership_org']?.toString();
    model.partnerRef = json['partner_ref']?.toString();
    model.tipoModulo = json['tipo_modulo']?.toString();
    model.idModulo = _parseInt(json['id_modulo']);
    model.idCorso = _parseInt(json['id_corso']);
    model.shorthNomeCorso = json['shorth_nome_corso']?.toString();
    model.nomeCorso = json['nome_corso']?.toString();
    model.tagId = _parseInt(json['tag_id']);
    model.ntag = json['ntag']?.toString();
    model.nomeAttivita = json['nome_attivita']?.toString();
    model.dataCompletamento = _parseDate(json['data_completamento']);
    return model;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    final str = value.toString().trim();
    if (str.isEmpty || str.toUpperCase() == 'NA' || str.toUpperCase() == 'NULL') return null;
    return int.tryParse(str);
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      if (value > 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    final str = value.toString().trim();
    if (str.isEmpty || str.toUpperCase() == 'NA' || str.toUpperCase() == 'NULL') return null;
    final intVal = int.tryParse(str);
    if (intVal != null && intVal > 0) {
      if (intVal > 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(intVal);
      }
      return DateTime.fromMillisecondsSinceEpoch(intVal * 1000);
    }
    try {
      return DateTime.parse(str);
    } catch (_) {}
    return null;
  }
}
