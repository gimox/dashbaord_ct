import 'package:isar_community/isar.dart';

part 'category.g.dart';

extension CategoryCollectionAlias on Isar {
  IsarCollection<Category> get categories => categorys;
}

@collection
class Category {
  Id id = Isar.autoIncrement;

  @Index()
  String? name;

  @Index()
  String? idnumber;

  String? description;
  int? descriptionformat;
  int? parent;
  int? sortorder;
  int? coursecount;
  int? visible;
  int? visibleold;
  int? timemodified;
  DateTime? timemodifiedDate;
  int? depth;
  String? path;
  String? theme;

  DateTime? lastSyncedAt;

  Category();

  // Helper per visibilità booleana
  @ignore
  bool get isVisible => visible == 1;

  // Helper per estrazione automatica dell'URL immagine dal tag <img> presente nella descrizione HTML
  @ignore
  String? get imageUrl {
    if (description == null || description!.isEmpty) return null;
    final regExp = RegExp(r'''<img[^>]+src=["']([^"']+)["']''', caseSensitive: false);
    final match = regExp.firstMatch(description!);
    return match?.group(1);
  }

  // Helper per descrizione pulita senza tag HTML
  @ignore
  String get plainDescription {
    if (description == null || description!.isEmpty) return '';
    return description!
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    int? parsedModified = (json['timemodified'] is num)
        ? (json['timemodified'] as num).toInt()
        : int.tryParse(json['timemodified']?.toString() ?? '');

    DateTime? modifiedDate;
    if (parsedModified != null && parsedModified > 0) {
      modifiedDate = DateTime.fromMillisecondsSinceEpoch(parsedModified * 1000);
    }

    return Category()
      ..id = (json['id'] is num)
          ? (json['id'] as num).toInt()
          : (int.tryParse(json['id']?.toString() ?? '') ?? Isar.autoIncrement)
      ..name = json['name']?.toString()
      ..idnumber = json['idnumber']?.toString()
      ..description = json['description']?.toString()
      ..descriptionformat = (json['descriptionformat'] is num)
          ? (json['descriptionformat'] as num).toInt()
          : int.tryParse(json['descriptionformat']?.toString() ?? '')
      ..parent = (json['parent'] is num)
          ? (json['parent'] as num).toInt()
          : int.tryParse(json['parent']?.toString() ?? '')
      ..sortorder = (json['sortorder'] is num)
          ? (json['sortorder'] as num).toInt()
          : int.tryParse(json['sortorder']?.toString() ?? '')
      ..coursecount = (json['coursecount'] is num)
          ? (json['coursecount'] as num).toInt()
          : int.tryParse(json['coursecount']?.toString() ?? '')
      ..visible = (json['visible'] is num)
          ? (json['visible'] as num).toInt()
          : (json['visible'] == true ? 1 : (json['visible'] == false ? 0 : null))
      ..visibleold = (json['visibleold'] is num)
          ? (json['visibleold'] as num).toInt()
          : int.tryParse(json['visibleold']?.toString() ?? '')
      ..timemodified = parsedModified
      ..timemodifiedDate = modifiedDate
      ..depth = (json['depth'] is num)
          ? (json['depth'] as num).toInt()
          : int.tryParse(json['depth']?.toString() ?? '')
      ..path = json['path']?.toString()
      ..theme = json['theme']?.toString()
      ..lastSyncedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'idnumber': idnumber,
      'description': description,
      'descriptionformat': descriptionformat,
      'parent': parent,
      'sortorder': sortorder,
      'coursecount': coursecount,
      'visible': visible,
      'visibleold': visibleold,
      'timemodified': timemodified,
      'depth': depth,
      'path': path,
      'theme': theme,
    };
  }
}
