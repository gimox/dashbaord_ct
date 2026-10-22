import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/feedback_for_bi.dart';

class FeedbackExcelExporter {
  /// Esporta la lista dei feedback in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportFeedback(List<FeedbackForBi> items) async {
    final excel = Excel.createExcel();
    const sheetName = 'Feedback CyberProTrain';

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
      'ID Record',
      'ID Corso',
      'Nome Corso',
      'Nome Feedback',
      'Lingua',
      'HQ1',
      'HQ2',
      'HQ3',
      'HQ4',
      'Media HQ',
      'Commento Testuale',
    ];

    // Scrittura Intestazione
    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = headerStyle;
    }
    sheet.setRowHeight(0, 30);

    // Scrittura Righe Dati
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final rowIndex = i + 1;
      final isEven = i % 2 == 0;
      final baseStyle = isEven ? rowEvenStyle : rowOddStyle;
      final centerStyle = isEven ? centerEvenStyle : centerOddStyle;

      sheet.setRowHeight(rowIndex, 24);

      // 0. ID Record
      final cellId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellId.value = IntCellValue(item.id);
      cellId.cellStyle = centerStyle;

      // 1. ID Corso
      final cellCourseId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellCourseId.value = item.courseId != null ? IntCellValue(item.courseId!) : TextCellValue('N/D');
      cellCourseId.cellStyle = centerStyle;

      // 2. Nome Corso
      final cellCourseName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellCourseName.value = TextCellValue(item.courseName ?? 'N/D');
      cellCourseName.cellStyle = baseStyle;

      // 3. Nome Feedback
      final cellFeedbackName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellFeedbackName.value = TextCellValue(item.feedbackName ?? 'N/D');
      cellFeedbackName.cellStyle = baseStyle;

      // 4. Lingua
      final cellLang = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cellLang.value = TextCellValue(item.lang ?? 'N/D');
      cellLang.cellStyle = centerStyle;

      // 5. HQ1
      final cellHq1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cellHq1.value = item.hq1 != null ? IntCellValue(item.hq1!) : TextCellValue('-');
      cellHq1.cellStyle = centerStyle;

      // 6. HQ2
      final cellHq2 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cellHq2.value = item.hq2 != null ? IntCellValue(item.hq2!) : TextCellValue('-');
      cellHq2.cellStyle = centerStyle;

      // 7. HQ3
      final cellHq3 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cellHq3.value = item.hq3 != null ? IntCellValue(item.hq3!) : TextCellValue('-');
      cellHq3.cellStyle = centerStyle;

      // 8. HQ4
      final cellHq4 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cellHq4.value = item.hq4 != null ? IntCellValue(item.hq4!) : TextCellValue('-');
      cellHq4.cellStyle = centerStyle;

      // 9. Media HQ
      final validHqs = [item.hq1, item.hq2, item.hq3, item.hq4].whereType<int>().toList();
      final cellAvg = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      if (validHqs.isNotEmpty) {
        final avg = validHqs.reduce((a, b) => a + b) / validHqs.length;
        cellAvg.value = DoubleCellValue(double.parse(avg.toStringAsFixed(2)));
      } else {
        cellAvg.value = TextCellValue('-');
      }
      cellAvg.cellStyle = centerStyle;

      // 10. Commento Testuale
      final cellText = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cellText.value = TextCellValue(item.text ?? '');
      cellText.cellStyle = baseStyle;
    }

    // Dimensionamento Colonne
    sheet.setColumnWidth(0, 12);
    sheet.setColumnWidth(1, 12);
    sheet.setColumnWidth(2, 38);
    sheet.setColumnWidth(3, 26);
    sheet.setColumnWidth(4, 10);
    sheet.setColumnWidth(5, 8);
    sheet.setColumnWidth(6, 8);
    sheet.setColumnWidth(7, 8);
    sheet.setColumnWidth(8, 8);
    sheet.setColumnWidth(9, 12);
    sheet.setColumnWidth(10, 40);

    // Salvataggio File tramite FilePicker
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Feedback_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Feedback',
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
