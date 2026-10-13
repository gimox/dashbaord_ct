import 'package:isar_community/isar.dart';

part 'badge_user.g.dart';

int _fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash & 0x7FFFFFFFFFFFFFFF;
}

extension BadgeUserCollectionAlias on Isar {
  IsarCollection<BadgeUser> get badgesUsers => badgeUsers;
}

@collection
class BadgeUser {
  Id id = Isar.autoIncrement;

  @Index()
  String? badge;

  @Index()
  String? code;

  @Index()
  String? email;

  String? issuedOn;

  DateTime? issuedOnDate;

  DateTime? lastSyncedAt;

  BadgeUser();

  factory BadgeUser.fromJson(Map<String, dynamic> json) {
    final item = BadgeUser();
    if (json['id'] != null) {
      if (json['id'] is num) {
        item.id = (json['id'] as num).toInt();
      } else {
        item.id = int.tryParse(json['id'].toString()) ?? Isar.autoIncrement;
      }
    }

    item.badge = json['badge']?.toString();
    item.code = json['code']?.toString();
    item.email = json['email']?.toString();
    item.issuedOn = json['issued_on']?.toString() ?? json['issuedOn']?.toString();

    if (item.issuedOn != null && item.issuedOn!.isNotEmpty) {
      try {
        item.issuedOnDate = DateTime.tryParse(item.issuedOn!);
      } catch (_) {}
    }

    // Se l'oggetto API non ha un id univoco numerico, genera un hash deterministico stabile
    if (json['id'] == null) {
      final key = '${item.email ?? ''}_${item.code ?? ''}_${item.badge ?? ''}_${item.issuedOn ?? ''}';
      if (key.trim().isNotEmpty) {
        item.id = _fastHash(key);
      }
    }

    item.lastSyncedAt = DateTime.now();
    return item;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge': badge,
      'code': code,
      'email': email,
      'issued_on': issuedOn,
      'issuedOnDate': issuedOnDate?.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    };
  }
}
