import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../models/course_active_stat.dart';

class CourseActiveStatsExcelExporter {
  /// Esporta la lista delle statistiche di iscrizione utenti attivi per corso in formato Excel (.xlsx)
  static Future<String?> exportStats(List<CourseActiveStat> items) async {
    final excel = Excel.createExcel();
    const sheetName = 'Iscrizioni Attive per Corso';

    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultSheet, sheetName);
    final sheet = excel[sheetName];

    // Stili Istituzionali
    final headerStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.white,
      backgroundColorHex: ExcelColor.fromHexString('#0F2027'),
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 11,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final rowEvenStyle = CellStyle(
      backgroundColorHex: ExcelColor.white,
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      verticalAlign: VerticalAlign.Center,
    );

    final rowOddStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      verticalAlign: VerticalAlign.Center,
    );

    final centerEvenStyle = CellStyle(
      backgroundColorHex: ExcelColor.white,
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final centerOddStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Intestazioni Colonne
    final headers = [
      'Posizione',
      'ID Corso',
      'Nome Corso',
      'Codice Corso',
      'Tipo Corso',
      'Iscritti Attivi',
      'Completati',
      '% Completamento',
      'Maschile (M)',
      '% Maschile',
      'Femminile (F)',
      '% Femminile',
      'Non Classificato (N.C.)',
      '% Non Classificato',
      'Lingue (Pref. Corso)',
    ];

    for (var colIndex = 0; colIndex < headers.length; colIndex++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0));
      cell.value = TextCellValue(headers[colIndex]);
      cell.cellStyle = headerStyle;
    }

    // Scrittura Righe Dati
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final rowIndex = i + 1;
      final isEven = i % 2 == 0;
      final rowStyle = isEven ? rowEvenStyle : rowOddStyle;
      final centerStyle = isEven ? centerEvenStyle : centerOddStyle;

      final total = item.total;
      final completionPct = item.completionPercentage.toStringAsFixed(1);
      final malePct = total > 0 ? (item.maleCount / total * 100).toStringAsFixed(1) : '0.0';
      final femalePct = total > 0 ? (item.femaleCount / total * 100).toStringAsFixed(1) : '0.0';
      final unclassifiedPct = total > 0 ? (item.unclassifiedCount / total * 100).toStringAsFixed(1) : '0.0';

      // 0. Posizione
      final cRank = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cRank.cellStyle = centerStyle;
      cRank.value = TextCellValue('#${i + 1}');

      // 1. ID Corso
      final cId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cId.cellStyle = centerStyle;
      cId.value = IntCellValue(item.courseId);

      // 2. Nome Corso
      final cName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cName.cellStyle = rowStyle;
      cName.value = TextCellValue(item.courseName);

      // 3. Codice Corso
      final cShort = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cShort.cellStyle = rowStyle;
      cShort.value = TextCellValue(item.courseShortname);

      // 4. Tipo Corso (SYNC / ASYNC)
      final cType = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cType.cellStyle = centerStyle;
      cType.value = TextCellValue(item.courseType.toUpperCase());

      // 5. Iscritti Attivi
      final cTotal = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cTotal.cellStyle = centerStyle;
      cTotal.value = IntCellValue(total);

      // 6. Completati
      final cCompleted = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cCompleted.cellStyle = centerStyle;
      cCompleted.value = IntCellValue(item.completedCount);

      // 7. % Completamento
      final cCompPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cCompPct.cellStyle = centerStyle;
      cCompPct.value = TextCellValue('$completionPct%');

      // 8. Maschile (M)
      final cMale = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cMale.cellStyle = centerStyle;
      cMale.value = IntCellValue(item.maleCount);

      // 9. % Maschile
      final cMalePct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cMalePct.cellStyle = centerStyle;
      cMalePct.value = TextCellValue('$malePct%');

      // 10. Femminile (F)
      final cFemale = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cFemale.cellStyle = centerStyle;
      cFemale.value = IntCellValue(item.femaleCount);

      // 11. % Femminile
      final cFemalePct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex));
      cFemalePct.cellStyle = centerStyle;
      cFemalePct.value = TextCellValue('$femalePct%');

      // 12. Non Classificato (N.C.)
      final cUnclass = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex));
      cUnclass.cellStyle = centerStyle;
      cUnclass.value = IntCellValue(item.unclassifiedCount);

      // 13. % Non Classificato
      final cUnclassPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex));
      cUnclassPct.cellStyle = centerStyle;
      cUnclassPct.value = TextCellValue('$unclassifiedPct%');

      // 14. Lingue (Pref. Corso)
      final langSummary = item.langCounts.isNotEmpty
          ? item.langCounts.entries.map((e) => '${e.key}: ${e.value}').join(', ')
          : '-';
      final cLangs = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex));
      cLangs.cellStyle = rowStyle;
      cLangs.value = TextCellValue(langSummary);
    }

    // Impostazione larghezze colonne
    sheet.setColumnWidth(0, 12);
    sheet.setColumnWidth(1, 14);
    sheet.setColumnWidth(2, 38);
    sheet.setColumnWidth(3, 22);
    sheet.setColumnWidth(4, 14);
    sheet.setColumnWidth(5, 16);
    sheet.setColumnWidth(6, 14);
    sheet.setColumnWidth(7, 18);
    sheet.setColumnWidth(8, 14);
    sheet.setColumnWidth(9, 14);
    sheet.setColumnWidth(10, 14);
    sheet.setColumnWidth(11, 14);
    sheet.setColumnWidth(12, 24);
    sheet.setColumnWidth(13, 20);
    sheet.setColumnWidth(14, 28);

    // Codifica file Excel
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Distribuzione_Corsi_Gender_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva report Excel Distribuzione Corsi',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: uint8List,
    );

    if (!kIsWeb && savedPath != null) {
      var finalPath = savedPath;
      if (!finalPath.toLowerCase().endsWith('.xlsx')) {
        finalPath += '.xlsx';
      }
      final file = uio.File(finalPath);
      await file.writeAsBytes(uint8List);
      return finalPath;
    }

    return savedPath ?? (kIsWeb ? fileName : null);
  }
}
