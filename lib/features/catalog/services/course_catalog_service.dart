import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';
import '../models/course_catalog_item.dart';
import '../../sync/models/course.dart';

class CourseCatalogService {
  static const String defaultAssetPath =
      'assets/report/catologo CYBER PRO TRAIN PARTNERS_2025_2026(settembre) 2.xlsx';

  /// Importa o aggiorna le voci di catalogo dal file Excel (asset predefinito o file fornito).
  static Future<int> importCatalogFromExcel(
    Isar isar, {
    List<int>? customBytes,
    String? customFilePath,
  }) async {
    List<int> bytes;

    if (customBytes != null && customBytes.isNotEmpty) {
      bytes = customBytes;
    } else if (customFilePath != null && customFilePath.isNotEmpty) {
      final file = File(customFilePath);
      if (!await file.exists()) {
        throw Exception('File Excel non trovato al percorso: $customFilePath');
      }
      bytes = await file.readAsBytes();
    } else {
      // Caricamento da bundle asset con fallback su file system locale
      try {
        final byteData = await rootBundle.load(defaultAssetPath);
        bytes = byteData.buffer.asUint8List();
      } catch (_) {
        final localFile = File(defaultAssetPath);
        if (await localFile.exists()) {
          bytes = await localFile.readAsBytes();
        } else {
          throw Exception('Impossibile caricare il catalogo Excel predefinito.');
        }
      }
    }

    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) {
      throw Exception('Il file Excel non contiene fogli di calcolo validi.');
    }

    final sheetName = excel.tables.keys.firstWhere(
      (k) => k.toUpperCase().contains('CATALOGUE') || k.toUpperCase().contains('CALENDAR'),
      orElse: () => excel.tables.keys.first,
    );
    final sheet = excel.tables[sheetName];
    if (sheet == null) {
      throw Exception('Foglio di catalogo non trovato.');
    }

    final allCourses = await isar.courses.where().findAll();
    final existingCatalog = await isar.courseCatalogItems.where().findAll();
    final existingMap = <String, CourseCatalogItem>{};
    for (final it in existingCatalog) {
      if (it.courseCode != null) {
        existingMap[it.courseCode!.trim().toUpperCase()] = it;
      }
    }

    String currentLearningPath = '';
    final List<CourseCatalogItem> itemsToSave = [];

    // Righe dati corso: dalla riga 7 (indice 6) alla riga 50 (indice 49)
    for (int r = 6; r <= 50 && r < sheet.maxRows; r++) {
      final row = sheet.rows[r];
      if (row.length <= 4) continue;

      // Percorso didattico (Col B / indice 1)
      final pathVal = row.length > 1 ? row[1]?.value?.toString().trim() : '';
      if (pathVal != null && pathVal.isNotEmpty) {
        currentLearningPath = pathVal;
      }

      // Codice corso (Col E / indice 4)
      final codeVal = row[4]?.value?.toString().trim();
      if (codeVal == null ||
          codeVal.isEmpty ||
          codeVal.toUpperCase() == 'TOTAL' ||
          codeVal.toUpperCase() == 'ID CORSI') {
        continue;
      }

      final titleEn = row.length > 2 ? row[2]?.value?.toString().trim() ?? '' : '';
      final titleIt = row.length > 3 ? row[3]?.value?.toString().trim() ?? '' : '';
      final durVal = row.length > 5 ? row[5]?.value?.toString().trim() ?? '' : '';
      final studyVal = row.length > 6 ? row[6]?.value?.toString().trim() ?? '' : '';

      final durHours = double.tryParse(durVal.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      final studyHours = double.tryParse(studyVal.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

      // Algoritmo di abbinamento automatico con corso locale Isar
      Course? matchedCourse;

      // 1. Abbinamento prioritario tramite campo personalizzato `imgc`
      for (final c in allCourses) {
        final imgc = c.customfields?.firstWhere(
          (cf) => cf.shortname?.toLowerCase() == 'imgc',
          orElse: () => CourseCustomField(),
        ).value?.trim();

        if (imgc != null && imgc.isNotEmpty) {
          if (codeVal.toUpperCase().endsWith('ADV')) {
            final baseCode = codeVal.replaceAll(RegExp(r'\s*ADV', caseSensitive: false), '').trim();
            if (imgc == 'Advanced $baseCode') {
              matchedCourse = c;
              break;
            }
            if (baseCode.startsWith('5.') && imgc == 'Strategic Technologies 1.${baseCode.substring(2)}') {
              matchedCourse = c;
              break;
            }
            if (baseCode.startsWith('6.') && imgc == 'Strategic Technologies 2.${baseCode.substring(2)}') {
              matchedCourse = c;
              break;
            }
          } else {
            if (imgc == 'Basic $codeVal') {
              matchedCourse = c;
              break;
            }
          }
        }
      }

      // 2. Abbinamento secondario tramite titolo ripulito da enumerazioni
      if (matchedCourse == null) {
        final cleanTitleEn = titleEn
            .replaceFirst(RegExp(r'^\d+\)\s*'), '')
            .split(':')
            .first
            .trim()
            .toLowerCase();
        for (final c in allCourses) {
          final cFull = (c.fullname ?? '').trim().toLowerCase();
          if (cFull.isNotEmpty && (cFull == cleanTitleEn || cleanTitleEn.startsWith(cFull))) {
            matchedCourse = c;
            break;
          }
        }
      }

      // Creazione o aggiornamento dell'entità
      final codeKey = codeVal.trim().toUpperCase();
      final item = existingMap[codeKey] ?? CourseCatalogItem();

      item.courseCode = codeVal;
      item.learningPath = currentLearningPath.replaceAll(RegExp(r'\s+'), ' ').trim();
      item.title = titleEn;
      item.titleIt = titleIt;
      item.durationHours = durHours;
      item.individualStudyHours = studyHours;
      item.updatedAt = DateTime.now();

      if (matchedCourse != null) {
        item.courseId = matchedCourse.id;
        item.courseShortname = matchedCourse.shortname;
        item.courseType = matchedCourse.courseType ?? 'async';
      }

      itemsToSave.add(item);
    }

    if (itemsToSave.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.courseCatalogItems.putAll(itemsToSave);
      });
    }

    return itemsToSave.length;
  }

  /// Recupera una mappa che associa `courseId` alla rispettiva durata in ore (`durationHours`).
  static Future<Map<int, double>> getCourseDurationMap(Isar isar) async {
    final items = await isar.courseCatalogItems.where().findAll();
    final map = <int, double>{};
    for (final it in items) {
      if (it.courseId != null && it.durationHours != null && it.durationHours! > 0) {
        map[it.courseId!] = it.durationHours!;
      }
    }
    return map;
  }

  /// Riesegue l'abbinamento automatico tra le voci di catalogo esistenti in Isar e i corsi Moodle.
  /// Utile dopo aver eseguito una sincronizzazione dei corsi da API Moodle.
  static Future<int> rematchCatalogWithMoodle(Isar isar) async {
    final allCourses = await isar.courses.where().findAll();
    final catalogItems = await isar.courseCatalogItems.where().findAll();

    if (catalogItems.isEmpty || allCourses.isEmpty) return 0;

    int matchedCount = 0;
    final updatedItems = <CourseCatalogItem>[];

    for (final item in catalogItems) {
      final codeVal = (item.courseCode ?? '').trim();
      Course? matchedCourse;

      // 1. Abbinamento per campo personalizzato `imgc`
      if (codeVal.isNotEmpty) {
        for (final c in allCourses) {
          final imgc = c.customfields?.firstWhere(
            (cf) => cf.shortname?.toLowerCase() == 'imgc',
            orElse: () => CourseCustomField(),
          ).value?.trim();

          if (imgc != null && imgc.isNotEmpty) {
            if (codeVal.toUpperCase().endsWith('ADV')) {
              final baseCode = codeVal.replaceAll(RegExp(r'\s*ADV', caseSensitive: false), '').trim();
              if (imgc == 'Advanced $baseCode') {
                matchedCourse = c;
                break;
              }
              if (baseCode.startsWith('5.') && imgc == 'Strategic Technologies 1.${baseCode.substring(2)}') {
                matchedCourse = c;
                break;
              }
              if (baseCode.startsWith('6.') && imgc == 'Strategic Technologies 2.${baseCode.substring(2)}') {
                matchedCourse = c;
                break;
              }
            } else {
              if (imgc == 'Basic $codeVal') {
                matchedCourse = c;
                break;
              }
            }
          }
        }
      }

      // 2. Abbinamento secondario per titolo
      if (matchedCourse == null && (item.title?.isNotEmpty ?? false)) {
        final cleanTitleEn = item.title!
            .replaceFirst(RegExp(r'^\d+\)\s*'), '')
            .split(':')
            .first
            .trim()
            .toLowerCase();
        for (final c in allCourses) {
          final cFull = (c.fullname ?? '').trim().toLowerCase();
          if (cFull.isNotEmpty && (cFull == cleanTitleEn || cleanTitleEn.startsWith(cFull))) {
            matchedCourse = c;
            break;
          }
        }
      }

      if (matchedCourse != null) {
        item.courseId = matchedCourse.id;
        item.courseShortname = matchedCourse.shortname;
        item.courseType = matchedCourse.courseType ?? 'async';
        item.updatedAt = DateTime.now();
        updatedItems.add(item);
        matchedCount++;
      } else if (item.courseId != null) {
        // Verifica se il corso a cui era collegato esiste ancora
        final stillExists = allCourses.any((c) => c.id == item.courseId);
        if (!stillExists) {
          item.courseId = null;
          item.courseShortname = null;
          item.updatedAt = DateTime.now();
          updatedItems.add(item);
        } else {
          matchedCount++;
        }
      }
    }

    if (updatedItems.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.courseCatalogItems.putAll(updatedItems);
      });
    }

    return matchedCount;
  }
}
