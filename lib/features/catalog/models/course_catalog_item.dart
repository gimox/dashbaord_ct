import 'package:isar_community/isar.dart';

part 'course_catalog_item.g.dart';

@collection
class CourseCatalogItem {
  Id id = Isar.autoIncrement;

  // Identificativo corso Moodle (se collegato al database locale Course)
  @Index()
  int? courseId;

  // Codice corso (es. 1.1, 1.2, 1.1 ADV, 5.1 ADV)
  @Index(unique: true, replace: true)
  String? courseCode;

  // Shortname Moodle (es. 4-introduction-)
  String? courseShortname;

  // Titolo corso EN
  String? title;

  // Titolo corso IT
  String? titleIt;

  // Modulo / Percorso formativo (es. CYBERSECURITY BASIC Module I)
  String? learningPath;

  // Durata in ore del corso (lezioni/aula/video)
  double? durationHours;

  // Ore di studio individuale
  double? individualStudyHours;

  // Tipologia corso (sync / async)
  String? courseType;

  // Note aggiuntive
  String? notes;

  DateTime? updatedAt;

  CourseCatalogItem();

  // Helper per durata totale
  @ignore
  double get totalHours => (durationHours ?? 0.0) + (individualStudyHours ?? 0.0);

  // Helper per classificazione oraria DG-CNECT KPI
  @ignore
  bool get isUpTo20Hours => (durationHours ?? 0.0) > 0 && (durationHours ?? 0.0) <= 20.0;

  @ignore
  bool get isBetween20And40Hours => (durationHours ?? 0.0) > 20.0 && (durationHours ?? 0.0) <= 40.0;
}
