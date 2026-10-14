import 'package:isar_community/isar.dart';

part 'course_exclusion.g.dart';

@collection
class CourseExclusion {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int courseId = 0;

  String? courseName;
  String? notes;
  DateTime? createdAt;

  CourseExclusion();
}
