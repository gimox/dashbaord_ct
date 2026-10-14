import '../../sync/models/course.dart';
import '../../sync/models/user.dart';
import '../../sync/models/user_course_enrolled.dart';

/// Modello aggregato per visualizzare l'iscrizione con dettagli completi di Utente e Corso
class EnrollmentItem {
  final UserCourseEnrolled enrolled;
  final User? user;
  final Course? course;

  EnrollmentItem({
    required this.enrolled,
    this.user,
    this.course,
  });

  int get id => enrolled.id;
  int get courseId => enrolled.courseId ?? 0;
  int get userId => enrolled.userId ?? 0;

  // Informazioni Utente
  String get userFullName {
    if (user != null) {
      if (user!.fullname != null && user!.fullname!.trim().isNotEmpty) {
        return user!.fullname!.trim();
      }
      final composed = '${user!.firstname ?? ''} ${user!.lastname ?? ''}'.trim();
      if (composed.isNotEmpty) return composed;
      if (user!.username != null && user!.username!.isNotEmpty) {
        return user!.username!;
      }
    }
    return 'Utente #$userId';
  }

  String get username => user?.username ?? '-';
  String get userEmail => user?.email ?? '-';
  String? get userDepartment => user?.department;

  String? getCustomFieldValue(String key) {
    if (user?.customfields != null) {
      for (final f in user!.customfields!) {
        final sname = (f.shortname ?? '').toLowerCase();
        final name = (f.name ?? '').toLowerCase();
        if (sname == key.toLowerCase() || name == key.toLowerCase()) {
          return f.value ?? f.displayvalue;
        }
      }
    }
    return null;
  }

  String? get userInstitution => getCustomFieldValue('institution') ?? getCustomFieldValue('istituzione');
  String? get userCity => getCustomFieldValue('city') ?? getCustomFieldValue('citta');
  bool get isUserSuspended => user?.suspended == true;
  bool get isUserConfirmed => user?.confirmed != false;

  String? get userGender {
    if (user?.customfields != null) {
      for (final f in user!.customfields!) {
        final sname = (f.shortname ?? '').toLowerCase();
        final name = (f.name ?? '').toLowerCase();
        if (sname == 'gender' || sname == 'sesso' || sname == 'genere' ||
            name == 'gender' || name == 'sesso' || name == 'genere') {
          return f.value ?? f.displayvalue;
        }
      }
    }
    return null;
  }

  // Informazioni Corso
  String get courseFullName => course?.fullname ?? 'Corso #$courseId';
  String get courseShortName => course?.shortname ?? '-';
  String get courseIdNumber => course?.idnumber ?? '-';
  int? get courseCategoryId => course?.categoryid;
  String get courseType => course?.courseType ?? 'sync';
  bool get isCourseVisible => course?.isVisible ?? false;
  DateTime? get courseStartDate => course?.startDateTime;
  DateTime? get courseEndDate => course?.endDateTime;
}
