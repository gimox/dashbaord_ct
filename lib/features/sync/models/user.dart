import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

part 'user.g.dart';

@embedded
class CustomField {
  String? type;
  String? value;
  String? displayvalue;
  String? name;
  String? shortname;

  CustomField({
    this.type,
    this.value,
    this.displayvalue,
    this.name,
    this.shortname,
  });

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      type: json['type']?.toString(),
      value: json['value']?.toString(),
      displayvalue: json['displayvalue']?.toString(),
      name: json['name']?.toString(),
      shortname: json['shortname']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'displayvalue': displayvalue,
      'name': name,
      'shortname': shortname,
    };
  }
}

@collection
class User {
  Id id = Isar.autoIncrement;

  String? username;
  String? firstname;
  String? lastname;
  String? fullname;
  String? department;
  int? firstaccess;
  int? lastaccess;
  String? auth;
  bool? suspended;
  bool? confirmed;
  String? lang;
  String? theme;
  String? timezone;
  int? mailformat;
  int? trackforums;
  String? description;
  int? descriptionformat;
  String? profileimageurlsmall;
  String? profileimageurl;
  String? email;

  List<CustomField>? customfields;

  @Index()
  DateTime? dateOfBirth;

  DateTime? lastSyncedAt;

  User();

  // Getter trasparente per data di nascita (legge dateOfBirth o estrae dai customfields se non ancora sincronizzata)
  @ignore
  DateTime? get effectiveDob => dateOfBirth ?? _parseDateOfBirth(customfields, null);

  // Getter calcolato per età
  @ignore
  int? get age {
    final dob = effectiveDob;
    if (dob == null) return null;
    final now = DateTime.now();
    int a = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      a--;
    }
    if (a < 0 || a > 115) return null;
    return a;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final cfs = (json['customfields'] is List)
        ? (json['customfields'] as List)
            .map((c) => CustomField.fromJson(c as Map<String, dynamic>))
            .toList()
        : null;

    final parsedDob = _parseDateOfBirth(cfs, json['date_of_birth'] ?? json['dob'] ?? json['birth']);

    return User()
      ..id = (json['id'] is num) ? (json['id'] as num).toInt() : Isar.autoIncrement
      ..username = json['username']?.toString()
      ..firstname = json['firstname']?.toString()
      ..lastname = json['lastname']?.toString()
      ..fullname = json['fullname']?.toString()
      ..department = json['department']?.toString()
      ..firstaccess = (json['firstaccess'] is num) ? (json['firstaccess'] as num).toInt() : null
      ..lastaccess = (json['lastaccess'] is num) ? (json['lastaccess'] as num).toInt() : null
      ..auth = json['auth']?.toString()
      ..suspended = json['suspended'] is bool ? json['suspended'] as bool : null
      ..confirmed = json['confirmed'] is bool ? json['confirmed'] as bool : null
      ..lang = json['lang']?.toString()
      ..theme = json['theme']?.toString()
      ..timezone = json['timezone']?.toString()
      ..mailformat = (json['mailformat'] is num) ? (json['mailformat'] as num).toInt() : null
      ..trackforums = (json['trackforums'] is num) ? (json['trackforums'] as num).toInt() : null
      ..description = json['description']?.toString()
      ..descriptionformat = (json['descriptionformat'] is num) ? (json['descriptionformat'] as num).toInt() : null
      ..profileimageurlsmall = json['profileimageurlsmall']?.toString()
      ..profileimageurl = json['profileimageurl']?.toString()
      ..email = json['email']?.toString()
      ..customfields = cfs
      ..dateOfBirth = parsedDob
      ..lastSyncedAt = DateTime.now();
  }

  static DateTime? _parseDateOfBirth(List<CustomField>? customfields, dynamic directField) {
    if (directField != null) {
      final parsed = tryParseDobString(directField.toString());
      if (parsed != null) return parsed;
    }

    if (customfields != null) {
      for (final cf in customfields) {
        final name = (cf.name ?? '').toLowerCase();
        final shortname = (cf.shortname ?? '').toLowerCase();
        if (name.contains('birth') ||
            name.contains('nascita') ||
            name.contains('dob') ||
            shortname.contains('birth') ||
            shortname.contains('nascita') ||
            shortname.contains('dob')) {
          final valStr = cf.value?.trim();
          if (valStr != null && valStr.isNotEmpty) {
            final parsed = tryParseDobString(valStr);
            if (parsed != null) return parsed;
          }
          final dispStr = cf.displayvalue?.trim();
          if (dispStr != null && dispStr.isNotEmpty) {
            final parsed = tryParseDobString(dispStr);
            if (parsed != null) return parsed;
          }
        }
      }
    }
    return null;
  }

  static DateTime? tryParseDobString(String str) {
    final trimmed = str.trim();
    if (trimmed.isEmpty) return null;

    final numVal = int.tryParse(trimmed);
    if (numVal != null) {
      if (numVal.abs() < 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(numVal * 1000);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(numVal);
      }
    }

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;

    final textFormats = [
      'd MMMM yyyy',
      'dd MMMM yyyy',
      'd MMM yyyy',
      'dd MMM yyyy',
      'MMMM d, yyyy',
      'MMM d, yyyy',
      'd-MMM-yyyy',
      'd-MMMM-yyyy',
    ];

    for (final fmt in textFormats) {
      try {
        return DateFormat(fmt, 'en_US').parseLoose(trimmed);
      } catch (_) {}
      try {
        return DateFormat(fmt, 'it_IT').parseLoose(trimmed);
      } catch (_) {}
    }

    final partsSlash = trimmed.split('/');
    if (partsSlash.length == 3) {
      final p0 = int.tryParse(partsSlash[0]);
      final p1 = int.tryParse(partsSlash[1]);
      final p2 = int.tryParse(partsSlash[2]);
      if (p0 != null && p1 != null && p2 != null) {
        return (p0 > 1000) ? DateTime(p0, p1, p2) : DateTime(p2, p1, p0);
      }
    }

    final partsDash = trimmed.split('-');
    if (partsDash.length == 3) {
      final p0 = int.tryParse(partsDash[0]);
      final p1 = int.tryParse(partsDash[1]);
      final p2 = int.tryParse(partsDash[2]);
      if (p0 != null && p1 != null && p2 != null) {
        return (p0 > 1000) ? DateTime(p0, p1, p2) : DateTime(p2, p1, p0);
      }
    }

    return null;
  }
}
