// ignore_for_file: non_constant_identifier_names

import 'package:isar_community/isar.dart';

part 'feedback_for_bi.g.dart';

@collection
class FeedbackForBi {
  Id id = Isar.autoIncrement;

  @Index()
  int? courseId;

  String? courseName;
  String? feedbackName;

  @Index()
  String? lang;

  int? hq1;
  int? hq2;
  int? hq3;
  int? hq4;

  String? text;

  // Convenience getters
  @ignore
  int? get course_id => courseId;
  @ignore
  String? get course_name => courseName;
  @ignore
  String? get feedback_name => feedbackName;
  @ignore
  int? get HQ1 => hq1;
  @ignore
  int? get HQ2 => hq2;
  @ignore
  int? get HQ3 => hq3;
  @ignore
  int? get HQ4 => hq4;

  FeedbackForBi();

  factory FeedbackForBi.fromJson(Map<String, dynamic> json) {
    final model = FeedbackForBi();
    model.courseId = _parseInt(json['course_id'] ?? json['courseId']);
    model.courseName = json['course_name']?.toString() ?? json['courseName']?.toString();
    model.feedbackName = json['feedback_name']?.toString() ?? json['feedbackName']?.toString();
    model.lang = json['lang']?.toString();
    model.hq1 = _parseInt(json['HQ1'] ?? json['hq1']);
    model.hq2 = _parseInt(json['HQ2'] ?? json['hq2']);
    model.hq3 = _parseInt(json['HQ3'] ?? json['hq3']);
    model.hq4 = _parseInt(json['HQ4'] ?? json['hq4']);
    model.text = json['text']?.toString();
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_name': courseName,
      'feedback_name': feedbackName,
      'lang': lang,
      'HQ1': hq1,
      'HQ2': hq2,
      'HQ3': hq3,
      'HQ4': hq4,
      'text': text,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    final str = value.toString().trim();
    if (str.isEmpty || str.toUpperCase() == 'NA' || str.toUpperCase() == 'NULL') return null;
    return int.tryParse(str);
  }
}
