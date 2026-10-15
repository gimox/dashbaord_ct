import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../models/age_active_stat.dart';

class AgeActiveStatsExcelExporter {
  /// Esporta la lista delle statistiche degli utenti attivi per fascia d'età in formato Excel (.xlsx)
  static Future<String?> exportStats(List<AgeActiveStat> items, {int totalActiveUsers = 0}) async {
    final excel = Excel.createExcel();
    const sheetName = 'Utenti Attivi per Età';

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
      'Fascia d\'Età',
      'Utenti Attivi',
      '% su Totale Attivi',
      'Completati',
      '% Completamento',
      'Maschile (M)',
      '% Maschile',
      'Femminile (F)',
      '% Femminile',
      'Non Classificato (N.C.)',
      '% Non Classificato',
      'Ripartizione Lingue',
    ];

    for (var colIndex = 0; colIndex < headers.length; colIndex++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0));
      cell.value = TextCellValue(headers[colIndex]);
      cell.cellStyle = headerStyle;
    }

    final grandTotal = totalActiveUsers > 0
        ? totalActiveUsers
        : items.fold<int>(0, (sum, i) => sum + i.total);

    // Scrittura Righe Dati
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final rowIndex = i + 1;
      final isEven = i % 2 == 0;
      final rowStyle = isEven ? rowEvenStyle : rowOddStyle;
      final centerStyle = isEven ? centerEvenStyle : centerOddStyle;

      final total = item.total;
      final sharePct = grandTotal > 0 ? (total / grandTotal * 100).toStringAsFixed(1) : '0.0';
      final malePct = item.malePercentage.toStringAsFixed(1);
      final femalePct = item.femalePercentage.toStringAsFixed(1);
      final unclassifiedPct = item.unclassifiedPercentage.toStringAsFixed(1);
      final compPct = item.completionPercentage.toStringAsFixed(1);

      // 0. Fascia d'Età
      final cLabel = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cLabel.cellStyle = rowStyle;
      cLabel.value = TextCellValue(item.label);

      // 1. Utenti Attivi
      final cTotal = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cTotal.cellStyle = centerStyle;
      cTotal.value = IntCellValue(total);

      // 2. % su Totale Attivi
      final cShare = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cShare.cellStyle = centerStyle;
      cShare.value = TextCellValue('$sharePct%');

      // 3. Completati
      final cComp = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cComp.cellStyle = centerStyle;
      cComp.value = IntCellValue(item.completedCount);

      // 4. % Completamento
      final cCompPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cCompPct.cellStyle = centerStyle;
      cCompPct.value = TextCellValue('$compPct%');

      // 5. Maschile (M)
      final cMale = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cMale.cellStyle = centerStyle;
      cMale.value = IntCellValue(item.maleCount);

      // 6. % Maschile
      final cMalePct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cMalePct.cellStyle = centerStyle;
      cMalePct.value = TextCellValue('$malePct%');

      // 7. Femminile (F)
      final cFemale = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cFemale.cellStyle = centerStyle;
      cFemale.value = IntCellValue(item.femaleCount);

      // 8. % Femminile
      final cFemalePct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cFemalePct.cellStyle = centerStyle;
      cFemalePct.value = TextCellValue('$femalePct%');

      // 9. Non Classificato (N.C.)
      final cUncl = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cUncl.cellStyle = centerStyle;
      cUncl.value = IntCellValue(item.unclassifiedCount);

      // 10. % Non Classificato
      final cUnclPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cUnclPct.cellStyle = centerStyle;
      cUnclPct.value = TextCellValue('$unclassifiedPct%');

      // 11. Ripartizione Lingue
      final langList = item.langCounts.entries.map((e) {
        final lang = e.key;
        final count = e.value;
        final genderMap = item.genderLangCounts[lang] ?? {};
        final m = genderMap['M'] ?? 0;
        final f = genderMap['F'] ?? 0;
        final nc = genderMap['N.C.'] ?? 0;
        return '$lang: $count (M: $m, F: $f, NC: $nc)';
      }).join('; ');

      final cLang = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex));
      cLang.cellStyle = rowStyle;
      cLang.value = TextCellValue(langList.isNotEmpty ? langList : 'N.D.');
    }

    // Auto-fit approssimato larghezze colonne
    sheet.setColumnWidth(0, 24);
    sheet.setColumnWidth(1, 14);
    sheet.setColumnWidth(2, 18);
    sheet.setColumnWidth(3, 14);
    sheet.setColumnWidth(4, 16);
    sheet.setColumnWidth(5, 14);
    sheet.setColumnWidth(6, 14);
    sheet.setColumnWidth(7, 14);
    sheet.setColumnWidth(8, 14);
    sheet.setColumnWidth(9, 20);
    sheet.setColumnWidth(10, 18);
    sheet.setColumnWidth(11, 45);

    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Age_Active_Users_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Distribuzione Età Utenti Attivi',
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
    return savedPath;
  }
}
