import 'package:isar_community/isar.dart';

part 'course.g.dart';

@embedded
class CourseFormatOption {
  String? name;
  int? value;

  CourseFormatOption();

  factory CourseFormatOption.fromJson(Map<String, dynamic> json) {
    return CourseFormatOption()
      ..name = json['name']?.toString()
      ..value = (json['value'] is num)
          ? (json['value'] as num).toInt()
          : int.tryParse(json['value']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

@embedded
class CourseCustomField {
  String? name;
  String? shortname;
  String? type;
  String? valueraw;
  String? value;

  CourseCustomField();

  factory CourseCustomField.fromJson(Map<String, dynamic> json) {
    return CourseCustomField()
      ..name = json['name']?.toString()
      ..shortname = json['shortname']?.toString()
      ..type = json['type']?.toString()
      ..valueraw = json['valueraw']?.toString()
      ..value = json['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'shortname': shortname,
      'type': type,
      'valueraw': valueraw,
      'value': value,
    };
  }
}

@collection
class Course {
  Id id = Isar.autoIncrement;

  @Index()
  String? shortname;

  @Index()
  int? categoryid;

  int? categorysortorder;

  @Index()
  String? fullname;

  String? displayname;

  @Index()
  String? idnumber;

  String? summary;
  int? summaryformat;
  String? format;
  int? showgrades;
  int? newsitems;
  int? startdate;
  DateTime? startDateTime;
  int? enddate;
  DateTime? endDateTime;
  int? numsections;
  int? maxbytes;
  int? showreports;
  int? visible;
  int? groupmode;
  int? groupmodeforce;
  int? defaultgroupingid;
  int? timecreated;
  DateTime? timecreatedDate;
  int? timemodified;
  DateTime? timemodifiedDate;
  int? enablecompletion;
  int? completionnotify;
  String? lang;
  String? forcetheme;

  List<CourseFormatOption>? courseformatoptions;

  bool? showactivitydates;
  bool? showcompletionconditions;

  List<CourseCustomField>? customfields;

  DateTime? lastSyncedAt;

  Course();

  // Helper per stato visibilità
  @ignore
  bool get isVisible => visible == 1;

  // Helper per tipo corso estratto dai custom fields
  @ignore
  String? get courseType {
    if (customfields == null) return null;
    for (final cf in customfields!) {
      if ((cf.shortname ?? '').toLowerCase() == 'course_type') {
        return cf.value ?? cf.valueraw;
      }
    }
    return null;
  }

  // Helper per riassunto pulito senza tag HTML
  @ignore
  String get cleanSummary {
    if (summary == null || summary!.isEmpty) return '';
    return summary!
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    int? parsedStart = (json['startdate'] is num)
        ? (json['startdate'] as num).toInt()
        : int.tryParse(json['startdate']?.toString() ?? '');
    DateTime? startDate;
    if (parsedStart != null && parsedStart > 0) {
      startDate = DateTime.fromMillisecondsSinceEpoch(parsedStart * 1000);
    }

    int? parsedEnd = (json['enddate'] is num)
        ? (json['enddate'] as num).toInt()
        : int.tryParse(json['enddate']?.toString() ?? '');
    DateTime? endDate;
    if (parsedEnd != null && parsedEnd > 0) {
      endDate = DateTime.fromMillisecondsSinceEpoch(parsedEnd * 1000);
    }

    int? parsedCreated = (json['timecreated'] is num)
        ? (json['timecreated'] as num).toInt()
        : int.tryParse(json['timecreated']?.toString() ?? '');
    DateTime? createdDate;
    if (parsedCreated != null && parsedCreated > 0) {
      createdDate = DateTime.fromMillisecondsSinceEpoch(parsedCreated * 1000);
    }

    int? parsedModified = (json['timemodified'] is num)
        ? (json['timemodified'] as num).toInt()
        : int.tryParse(json['timemodified']?.toString() ?? '');
    DateTime? modifiedDate;
    if (parsedModified != null && parsedModified > 0) {
      modifiedDate = DateTime.fromMillisecondsSinceEpoch(parsedModified * 1000);
    }

    // Parsing opzioni formato corso
    List<CourseFormatOption>? formatOpts;
    if (json['courseformatoptions'] is List) {
      formatOpts = (json['courseformatoptions'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => CourseFormatOption.fromJson(e))
          .toList();
    }

    // Parsing custom fields
    List<CourseCustomField>? cFields;
    if (json['customfields'] is List) {
      cFields = (json['customfields'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => CourseCustomField.fromJson(e))
          .toList();
    }

    return Course()
      ..id = (json['id'] is num)
          ? (json['id'] as num).toInt()
          : (int.tryParse(json['id']?.toString() ?? '') ?? Isar.autoIncrement)
      ..shortname = json['shortname']?.toString()
      ..categoryid = (json['categoryid'] is num)
          ? (json['categoryid'] as num).toInt()
          : int.tryParse(json['categoryid']?.toString() ?? '')
      ..categorysortorder = (json['categorysortorder'] is num)
          ? (json['categorysortorder'] as num).toInt()
          : int.tryParse(json['categorysortorder']?.toString() ?? '')
      ..fullname = json['fullname']?.toString()
      ..displayname = json['displayname']?.toString()
      ..idnumber = json['idnumber']?.toString()
      ..summary = json['summary']?.toString()
      ..summaryformat = (json['summaryformat'] is num)
          ? (json['summaryformat'] as num).toInt()
          : int.tryParse(json['summaryformat']?.toString() ?? '')
      ..format = json['format']?.toString()
      ..showgrades = (json['showgrades'] is num)
          ? (json['showgrades'] as num).toInt()
          : int.tryParse(json['showgrades']?.toString() ?? '')
      ..newsitems = (json['newsitems'] is num)
          ? (json['newsitems'] as num).toInt()
          : int.tryParse(json['newsitems']?.toString() ?? '')
      ..startdate = parsedStart
      ..startDateTime = startDate
      ..enddate = parsedEnd
      ..endDateTime = endDate
      ..numsections = (json['numsections'] is num)
          ? (json['numsections'] as num).toInt()
          : int.tryParse(json['numsections']?.toString() ?? '')
      ..maxbytes = (json['maxbytes'] is num)
          ? (json['maxbytes'] as num).toInt()
          : int.tryParse(json['maxbytes']?.toString() ?? '')
      ..showreports = (json['showreports'] is num)
          ? (json['showreports'] as num).toInt()
          : int.tryParse(json['showreports']?.toString() ?? '')
      ..visible = (json['visible'] is num)
          ? (json['visible'] as num).toInt()
          : (json['visible'] == true ? 1 : (json['visible'] == false ? 0 : null))
      ..groupmode = (json['groupmode'] is num)
          ? (json['groupmode'] as num).toInt()
          : int.tryParse(json['groupmode']?.toString() ?? '')
      ..groupmodeforce = (json['groupmodeforce'] is num)
          ? (json['groupmodeforce'] as num).toInt()
          : int.tryParse(json['groupmodeforce']?.toString() ?? '')
      ..defaultgroupingid = (json['defaultgroupingid'] is num)
          ? (json['defaultgroupingid'] as num).toInt()
          : int.tryParse(json['defaultgroupingid']?.toString() ?? '')
      ..timecreated = parsedCreated
      ..timecreatedDate = createdDate
      ..timemodified = parsedModified
      ..timemodifiedDate = modifiedDate
      ..enablecompletion = (json['enablecompletion'] is num)
          ? (json['enablecompletion'] as num).toInt()
          : int.tryParse(json['enablecompletion']?.toString() ?? '')
      ..completionnotify = (json['completionnotify'] is num)
          ? (json['completionnotify'] as num).toInt()
          : int.tryParse(json['completionnotify']?.toString() ?? '')
      ..lang = json['lang']?.toString()
      ..forcetheme = json['forcetheme']?.toString()
      ..courseformatoptions = formatOpts
      ..showactivitydates = json['showactivitydates'] is bool
          ? json['showactivitydates'] as bool
          : null
      ..showcompletionconditions = json['showcompletionconditions'] is bool
          ? json['showcompletionconditions'] as bool
          : null
      ..customfields = cFields
      ..lastSyncedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortname': shortname,
      'categoryid': categoryid,
      'categorysortorder': categorysortorder,
      'fullname': fullname,
      'displayname': displayname,
      'idnumber': idnumber,
      'summary': summary,
      'summaryformat': summaryformat,
      'format': format,
      'showgrades': showgrades,
      'newsitems': newsitems,
      'startdate': startdate,
      'enddate': enddate,
      'numsections': numsections,
      'maxbytes': maxbytes,
      'showreports': showreports,
      'visible': visible,
      'groupmode': groupmode,
      'groupmodeforce': groupmodeforce,
      'defaultgroupingid': defaultgroupingid,
      'timecreated': timecreated,
      'timemodified': timemodified,
      'enablecompletion': enablecompletion,
      'completionnotify': completionnotify,
      'lang': lang,
      'forcetheme': forcetheme,
      'courseformatoptions': courseformatoptions?.map((e) => e.toJson()).toList(),
      'showactivitydates': showactivitydates,
      'showcompletionconditions': showcompletionconditions,
      'customfields': customfields?.map((e) => e.toJson()).toList(),
    };
  }
}
