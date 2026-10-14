import '../../sync/models/stat_mdl.dart';

/// Modello aggregato per raggruppamento statistiche per (Utente, Corso)
class UserCourseStatGroup {
  final int? userId;
  final String? username;
  final String fullName;
  final String? email;

  final int? idCorso;
  final String? shorthNomeCorso;
  final String? nomeCorso;

  final String? statoCompletamentoCorso;
  final DateTime? dataCompletamentoCorso;
  final DateTime? primoAccessoPiattaforma;
  final DateTime? ultimoAccessoPiattaforma;

  final String? gender;
  final String? dateOfBirthCnv;
  final String? qualification;
  final String? membershipOrg;
  final String? userCourseLang;

  final List<StatMdl> activities;

  UserCourseStatGroup({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.email,
    required this.idCorso,
    required this.shorthNomeCorso,
    required this.nomeCorso,
    required this.statoCompletamentoCorso,
    required this.dataCompletamentoCorso,
    required this.primoAccessoPiattaforma,
    required this.ultimoAccessoPiattaforma,
    required this.gender,
    required this.dateOfBirthCnv,
    required this.qualification,
    required this.membershipOrg,
    required this.userCourseLang,
    required this.activities,
  });

  int get totalActivities => activities.length;

  int get completedActivities =>
      activities.where((a) => a.dataCompletamento != null).length;

  double get completionProgress =>
      totalActivities > 0 ? (completedActivities / totalActivities) : 0.0;

  bool get isCourseCompleted =>
      (statoCompletamentoCorso ?? '').toLowerCase() == 'completato' ||
      dataCompletamentoCorso != null;

  /// Se all'interno del gruppo di moduli esiste un modulo con [ntag] == 'meet',
  /// il corso è SEMPRE 'sync' (anche in presenza di altri valori).
  /// Altrimenti, se esiste un modulo con [ntag] == 'async' o 'asyncp', è 'async', altrimenti 'sync'.
  String get courseType {
    final hasMeet = activities.any(
      (a) => (a.ntag ?? '').trim().toLowerCase() == 'meet',
    );
    if (hasMeet) return 'sync';

    const asyncTags = {'async', 'asyncp'};
    final isAsyncCourse = activities.any(
      (a) => asyncTags.contains((a.ntag ?? '').trim().toLowerCase()),
    );
    return isAsyncCourse ? 'async' : 'sync';
  }

  // ignore: non_constant_identifier_names
  String get course_type => courseType;

  bool get isAsync => courseType == 'async';
}

