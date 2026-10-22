import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../models/feedback_dashboard_stat.dart';

class FeedbackDashboardStatsExcelExporter {
  /// Esporta le statistiche generali e per corso dei feedback in formato Excel (.xlsx)
  static Future<String?> exportStats({
    required List<FeedbackLangStat> langStats,
    required List<CourseFeedbackStat> courseStats,
  }) async {
    final excel = Excel.createExcel();

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

    // ==========================================
    // FOGLIO 1: Medie per Lingua (Generale)
    // ==========================================
    const sheet1Name = 'Medie Feedback per Lingua';
    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultSheet, sheet1Name);
    final sheet1 = excel[sheet1Name];

    final headers1 = [
      'Lingua',
      'Feedback Totali',
      'Media Generale',
      'Media HQ1',
      'Media HQ2',
      'Media HQ3',
      'Media HQ4',
      'Commenti Testuali',
    ];

    sheet1.appendRow(headers1.map((h) => TextCellValue(h)).toList());
    for (int col = 0; col < headers1.length; col++) {
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).cellStyle = headerStyle;
    }

    int rowIndex1 = 1;
    for (final s in langStats) {
      final isEven = rowIndex1 % 2 == 0;
      final currentCenter = isEven ? centerEvenStyle : centerOddStyle;

      sheet1.appendRow([
        TextCellValue(s.lang),
        IntCellValue(s.count),
        DoubleCellValue(double.parse(s.averageScore.toStringAsFixed(2))),
        DoubleCellValue(double.parse(s.avgHq1.toStringAsFixed(2))),
        DoubleCellValue(double.parse(s.avgHq2.toStringAsFixed(2))),
        DoubleCellValue(double.parse(s.avgHq3.toStringAsFixed(2))),
        DoubleCellValue(double.parse(s.avgHq4.toStringAsFixed(2))),
        IntCellValue(s.textCount),
      ]);

      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex1)).cellStyle = currentCenter;
      sheet1.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex1)).cellStyle = currentCenter;

      rowIndex1++;
    }

    sheet1.setColumnWidth(0, 16);
    sheet1.setColumnWidth(1, 18);
    sheet1.setColumnWidth(2, 18);
    sheet1.setColumnWidth(3, 16);
    sheet1.setColumnWidth(4, 16);
    sheet1.setColumnWidth(5, 16);
    sheet1.setColumnWidth(6, 16);
    sheet1.setColumnWidth(7, 20);

    // ==========================================
    // FOGLIO 2: Medie per Corso e Lingua
    // ==========================================
    const sheet2Name = 'Feedback per Corso e Lingua';
    final sheet2 = excel[sheet2Name];

    final headers2 = [
      'ID Corso',
      'Nome Corso',
      'Codice Breve',
      'Feedback Totali',
      'Media Corso',
      'Lingua',
      'Feedback Lingua',
      'Media Lingua',
      'Media HQ1',
      'Media HQ2',
      'Media HQ3',
      'Media HQ4',
    ];

    sheet2.appendRow(headers2.map((h) => TextCellValue(h)).toList());
    for (int col = 0; col < headers2.length; col++) {
      sheet2.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).cellStyle = headerStyle;
    }

    int rowIndex2 = 1;
    for (final c in courseStats) {
      final isEven = rowIndex2 % 2 == 0;
      final currentStyle = isEven ? rowEvenStyle : rowOddStyle;
      final currentCenter = isEven ? centerEvenStyle : centerOddStyle;

      if (c.langStats.isEmpty) {
        sheet2.appendRow([
          IntCellValue(c.courseId),
          TextCellValue(c.courseName),
          TextCellValue(c.courseShortname),
          IntCellValue(c.totalFeedbackCount),
          DoubleCellValue(double.parse(c.overallAverage.toStringAsFixed(2))),
          TextCellValue('-'),
          const IntCellValue(0),
          const DoubleCellValue(0.0),
          const DoubleCellValue(0.0),
          const DoubleCellValue(0.0),
          const DoubleCellValue(0.0),
          const DoubleCellValue(0.0),
        ]);
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex2)).cellStyle = currentStyle;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex2)).cellStyle = currentCenter;
        sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex2)).cellStyle = currentCenter;
        rowIndex2++;
      } else {
        for (final lKey in c.sortedLanguages) {
          final lStat = c.langStats[lKey]!;
          sheet2.appendRow([
            IntCellValue(c.courseId),
            TextCellValue(c.courseName),
            TextCellValue(c.courseShortname),
            IntCellValue(c.totalFeedbackCount),
            DoubleCellValue(double.parse(c.overallAverage.toStringAsFixed(2))),
            TextCellValue(lStat.lang),
            IntCellValue(lStat.count),
            DoubleCellValue(double.parse(lStat.averageScore.toStringAsFixed(2))),
            DoubleCellValue(double.parse(lStat.avgHq1.toStringAsFixed(2))),
            DoubleCellValue(double.parse(lStat.avgHq2.toStringAsFixed(2))),
            DoubleCellValue(double.parse(lStat.avgHq3.toStringAsFixed(2))),
            DoubleCellValue(double.parse(lStat.avgHq4.toStringAsFixed(2))),
          ]);

          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex2)).cellStyle = currentStyle;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex2)).cellStyle = currentCenter;
          sheet2.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex2)).cellStyle = currentCenter;
          rowIndex2++;
        }
      }
    }

    sheet2.setColumnWidth(0, 12);
    sheet2.setColumnWidth(1, 40);
    sheet2.setColumnWidth(2, 22);
    sheet2.setColumnWidth(3, 16);
    sheet2.setColumnWidth(4, 16);
    sheet2.setColumnWidth(5, 14);
    sheet2.setColumnWidth(6, 18);
    sheet2.setColumnWidth(7, 16);
    sheet2.setColumnWidth(8, 14);
    sheet2.setColumnWidth(9, 14);
    sheet2.setColumnWidth(10, 14);
    sheet2.setColumnWidth(11, 14);

    // Salvataggio del file Excel
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final defaultFileName = 'Statistiche_Feedback_Dashboard_$dateStr.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva Statistiche Feedback Excel',
      fileName: defaultFileName,
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

    return savedPath ?? (kIsWeb ? defaultFileName : null);
  }
}
