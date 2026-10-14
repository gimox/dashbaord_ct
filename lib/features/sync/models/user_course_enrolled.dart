import 'package:isar_community/isar.dart';

part 'user_course_enrolled.g.dart';

@collection
class UserCourseEnrolled {
  Id id = Isar.autoIncrement;

  @Index()
  int? courseId;

  @Index()
  int? userId;

  UserCourseEnrolled();

  factory UserCourseEnrolled.fromJson(Map<String, dynamic> json) {
    final model = UserCourseEnrolled();
    model.courseId = _parseInt(json['course_id'] ?? json['courseid'] ?? json['id_corso']);
    model.userId = _parseInt(json['user_id'] ?? json['userid'] ?? json['id_utente'] ?? json['id']);
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'user_id': userId,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }
}
