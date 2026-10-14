import 'package:isar_community/isar.dart';

part 'course_info.g.dart';

extension CourseInfoCollectionAlias on Isar {
  IsarCollection<CourseInfo> get courseInfo => courseInfos;
}

@embedded
class CourseModule {
  int? id;
  String? url;
  String? name;
  int? instance;
  int? contextid;
  int? visible;
  bool? uservisible;
  int? visibleoncoursepage;
  String? modicon;
  String? modname;
  String? purpose;
  bool? branded;
  String? modplural;
  String? availability;
  int? indent;
  String? onclick;
  String? afterlink;
  String? customdata;
  bool? noviewlink;
  int? completion;
  int? downloadcontent;
  int? groupmode;
  List<String>? activitybadge;
  List<String>? dates;

  CourseModule();

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    final mod = CourseModule();
    mod.id = (json['id'] is num)
        ? (json['id'] as num).toInt()
        : int.tryParse(json['id']?.toString() ?? '');
    mod.url = json['url']?.toString();
    mod.name = json['name']?.toString();
    mod.instance = (json['instance'] is num)
        ? (json['instance'] as num).toInt()
        : int.tryParse(json['instance']?.toString() ?? '');
    mod.contextid = (json['contextid'] is num)
        ? (json['contextid'] as num).toInt()
        : int.tryParse(json['contextid']?.toString() ?? '');
    mod.visible = (json['visible'] is num)
        ? (json['visible'] as num).toInt()
        : int.tryParse(json['visible']?.toString() ?? '');
    mod.uservisible = json['uservisible'] is bool
        ? json['uservisible'] as bool
        : (json['uservisible']?.toString().toLowerCase() == 'true' || json['uservisible'] == 1);
    mod.visibleoncoursepage = (json['visibleoncoursepage'] is num)
        ? (json['visibleoncoursepage'] as num).toInt()
        : int.tryParse(json['visibleoncoursepage']?.toString() ?? '');
    mod.modicon = json['modicon']?.toString();
    mod.modname = json['modname']?.toString();
    mod.purpose = json['purpose']?.toString();
    mod.branded = json['branded'] is bool
        ? json['branded'] as bool
        : (json['branded']?.toString().toLowerCase() == 'true');
    mod.modplural = json['modplural']?.toString();
    mod.availability = json['availability']?.toString();
    mod.indent = (json['indent'] is num)
        ? (json['indent'] as num).toInt()
        : int.tryParse(json['indent']?.toString() ?? '');
    mod.onclick = json['onclick']?.toString();
    mod.afterlink = json['afterlink']?.toString();
    mod.customdata = json['customdata']?.toString();
    mod.noviewlink = json['noviewlink'] is bool
        ? json['noviewlink'] as bool
        : (json['noviewlink']?.toString().toLowerCase() == 'true');
    mod.completion = (json['completion'] is num)
        ? (json['completion'] as num).toInt()
        : int.tryParse(json['completion']?.toString() ?? '');
    mod.downloadcontent = (json['downloadcontent'] is num)
        ? (json['downloadcontent'] as num).toInt()
        : int.tryParse(json['downloadcontent']?.toString() ?? '');
    mod.groupmode = (json['groupmode'] is num)
        ? (json['groupmode'] as num).toInt()
        : int.tryParse(json['groupmode']?.toString() ?? '');

    if (json['activitybadge'] is List) {
      mod.activitybadge = (json['activitybadge'] as List)
          .map((e) => e.toString())
          .toList();
    }
    if (json['dates'] is List) {
      mod.dates = (json['dates'] as List)
          .map((e) => e.toString())
          .toList();
    }
    return mod;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'instance': instance,
      'contextid': contextid,
      'visible': visible,
      'uservisible': uservisible,
      'visibleoncoursepage': visibleoncoursepage,
      'modicon': modicon,
      'modname': modname,
      'purpose': purpose,
      'branded': branded,
      'modplural': modplural,
      'availability': availability,
      'indent': indent,
      'onclick': onclick,
      'afterlink': afterlink,
      'customdata': customdata,
      'noviewlink': noviewlink,
      'completion': completion,
      'downloadcontent': downloadcontent,
      'groupmode': groupmode,
      'activitybadge': activitybadge,
      'dates': dates,
    };
  }
}

@collection
class CourseInfo {
  Id id = Isar.autoIncrement;

  @Index()
  String? name;

  int? visible;

  String? summary;

  int? summaryformat;

  int? section;

  int? hiddenbynumsections;

  bool? uservisible;

  String? component;

  int? itemid;

  @Index()
  int? courseId;

  List<CourseModule>? modules;

  DateTime? lastSyncedAt;

  CourseInfo();

  factory CourseInfo.fromJson(Map<String, dynamic> json, {int? courseId}) {
    final item = CourseInfo();
    if (json['id'] != null) {
      if (json['id'] is num) {
        item.id = (json['id'] as num).toInt();
      } else {
        item.id = int.tryParse(json['id'].toString()) ?? Isar.autoIncrement;
      }
    }

    item.name = json['name']?.toString();
    item.visible = (json['visible'] is num)
        ? (json['visible'] as num).toInt()
        : int.tryParse(json['visible']?.toString() ?? '');
    item.summary = json['summary']?.toString();
    item.summaryformat = (json['summaryformat'] is num)
        ? (json['summaryformat'] as num).toInt()
        : int.tryParse(json['summaryformat']?.toString() ?? '');
    item.section = (json['section'] is num)
        ? (json['section'] as num).toInt()
        : int.tryParse(json['section']?.toString() ?? '');
    item.hiddenbynumsections = (json['hiddenbynumsections'] is num)
        ? (json['hiddenbynumsections'] as num).toInt()
        : int.tryParse(json['hiddenbynumsections']?.toString() ?? '');
    item.uservisible = json['uservisible'] is bool
        ? json['uservisible'] as bool
        : (json['uservisible']?.toString().toLowerCase() == 'true' || json['uservisible'] == 1);
    item.component = json['component']?.toString();
    item.itemid = (json['itemid'] is num)
        ? (json['itemid'] as num).toInt()
        : int.tryParse(json['itemid']?.toString() ?? '');

    if (courseId != null) {
      item.courseId = courseId;
    } else if (json['courseid'] != null || json['course_id'] != null || json['course'] != null) {
      final rawCourseId = json['courseid'] ?? json['course_id'] ?? json['course'];
      item.courseId = (rawCourseId is num)
          ? rawCourseId.toInt()
          : int.tryParse(rawCourseId.toString());
    }

    if (json['modules'] is List) {
      final List<CourseModule> parsedModules = [];
      for (final m in json['modules'] as List) {
        if (m is Map) {
          try {
            parsedModules.add(CourseModule.fromJson(Map<String, dynamic>.from(m)));
          } catch (_) {}
        }
      }
      item.modules = parsedModules;
    }

    item.lastSyncedAt = DateTime.now();
    return item;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'visible': visible,
      'summary': summary,
      'summaryformat': summaryformat,
      'section': section,
      'hiddenbynumsections': hiddenbynumsections,
      'uservisible': uservisible,
      'component': component,
      'itemid': itemid,
      'courseId': courseId,
      'modules': modules?.map((m) => m.toJson()).toList(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    };
  }
}
