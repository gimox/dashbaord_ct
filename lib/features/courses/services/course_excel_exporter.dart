import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/course.dart';

class CourseExcelExporter {
  /// Esporta la lista dei corsi in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportCourses(List<Course> courses) async {
    final excel = Excel.createExcel();
    const sheetName = 'Corsi CyberProTrain';

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

    final hiddenRowStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#FEF2F2'),
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#991B1B'),
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
      'ID',
      'Nome Breve (Shortname)',
      'Titolo Completo (Fullname)',
      'Codice (IDNumber)',
      'Categoria ID',
      'Formato',
      'Tipo Corso',
      'Visibile',
      'Data Inizio',
      'Data Fine',
      'Ultima Modifica',
      'Riassunto',
    ];

    for (int c = 0; c < headers.length; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0));
      cell.value = TextCellValue(headers[c]);
      cell.cellStyle = headerStyle;
    }

    // Riempimento Dati
    for (int i = 0; i < courses.length; i++) {
      final course = courses[i];
      final rowIndex = i + 1;
      final isHidden = course.visible == 0;
      final baseStyle = isHidden ? hiddenRowStyle : (i.isEven ? rowEvenStyle : rowOddStyle);
      final centerStyle = isHidden ? hiddenRowStyle : (i.isEven ? centerEvenStyle : centerOddStyle);

      // 1. ID
      final cellId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellId.value = IntCellValue(course.id);
      cellId.cellStyle = centerStyle;

      // 2. Shortname
      final cellShort = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellShort.value = TextCellValue(course.shortname ?? '');
      cellShort.cellStyle = baseStyle;

      // 3. Fullname
      final cellFull = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellFull.value = TextCellValue(course.fullname ?? '');
      cellFull.cellStyle = baseStyle;

      // 4. IDNumber
      final cellIdNum = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellIdNum.value = TextCellValue(course.idnumber ?? '');
      cellIdNum.cellStyle = centerStyle;

      // 5. Categoria ID
      final cellCat = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cellCat.value = IntCellValue(course.categoryid ?? 0);
      cellCat.cellStyle = centerStyle;

      // 6. Formato
      final cellFormat = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cellFormat.value = TextCellValue(course.format ?? '');
      cellFormat.cellStyle = centerStyle;

      // 7. Tipo Corso (custom field)
      final cellType = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cellType.value = TextCellValue(course.courseType ?? '');
      cellType.cellStyle = centerStyle;

      // 8. Visibile
      final cellVis = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cellVis.value = TextCellValue(course.isVisible ? 'Sì' : 'No');
      cellVis.cellStyle = centerStyle;

      // 9. Data Inizio
      final cellStart = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cellStart.cellStyle = centerStyle;
      if (course.startDateTime != null) {
        cellStart.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(course.startDateTime!));
      } else {
        cellStart.value = TextCellValue('N/D');
      }

      // 10. Data Fine
      final cellEnd = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cellEnd.cellStyle = centerStyle;
      if (course.endDateTime != null) {
        cellEnd.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(course.endDateTime!));
      } else {
        cellEnd.value = TextCellValue('N/D');
      }

      // 11. Data Ultima Modifica
      final cellMod = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cellMod.cellStyle = centerStyle;
      if (course.timemodifiedDate != null) {
        cellMod.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(course.timemodifiedDate!));
      } else {
        cellMod.value = TextCellValue('N/D');
      }

      // 12. Riassunto
      final cellDesc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex));
      cellDesc.value = TextCellValue(course.cleanSummary);
      cellDesc.cellStyle = baseStyle;
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 10);
    sheet.setColumnWidth(1, 20);
    sheet.setColumnWidth(2, 35);
    sheet.setColumnWidth(3, 16);
    sheet.setColumnWidth(4, 14);
    sheet.setColumnWidth(5, 14);
    sheet.setColumnWidth(6, 16);
    sheet.setColumnWidth(7, 12);
    sheet.setColumnWidth(8, 20);
    sheet.setColumnWidth(9, 20);
    sheet.setColumnWidth(10, 20);
    sheet.setColumnWidth(11, 40);

    // Salvataggio File tramite FilePicker
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Courses_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Corsi',
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
