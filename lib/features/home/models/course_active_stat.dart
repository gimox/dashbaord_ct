class CourseActiveStat {
  final int courseId;
  final String courseName;
  final String courseShortname;
  final String courseType; // 'sync' | 'async'
  int maleCount = 0;
  int femaleCount = 0;
  int unclassifiedCount = 0;
  int completedCount = 0;
  Map<String, int> langCounts = {};

  CourseActiveStat({
    required this.courseId,
    required this.courseName,
    required this.courseShortname,
    required this.courseType,
    this.completedCount = 0,
    Map<String, int>? langCounts,
  }) : langCounts = langCounts ?? {};

  int get total => maleCount + femaleCount + unclassifiedCount;

  double get completionPercentage =>
      total > 0 ? (completedCount / total * 100) : 0.0;

  bool get isAsync => courseType.trim().toLowerCase() == 'async';
  bool get isSync => !isAsync;
}
