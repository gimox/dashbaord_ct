import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../models/enrollment_item.dart';

class EnrollmentsExcelExporter {
  /// Esporta la lista delle iscrizioni in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportEnrollments(List<EnrollmentItem> items) async {
    final excel = Excel.createExcel();
    const sheetName = 'Iscrizioni CyberProTrain';

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
      'ID Iscrizione',
      'ID Utente',
      'Utente (Nome e Cognome)',
      'Username',
      'Email',
      'Genere',
      'Dipartimento',
      'Istituzione',
      'ID Corso',
      'Titolo Corso (Fullname)',
      'Codice Corso (Shortname)',
      'IDNumber Corso',
      'Tipo Corso',
      'Visibile',
      'Data Inizio Corso',
      'Data Fine Corso',
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

      // 1. ID Iscrizione
      final cellId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellId.value = IntCellValue(item.id);
      cellId.cellStyle = centerStyle;

      // 2. ID Utente
      final cellUserId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellUserId.value = IntCellValue(item.userId);
      cellUserId.cellStyle = centerStyle;

      // 3. Utente
      final cellUser = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellUser.value = TextCellValue(item.userFullName);
      cellUser.cellStyle = baseStyle;

      // 4. Username
      final cellUsername = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellUsername.value = TextCellValue(item.username);
      cellUsername.cellStyle = baseStyle;

      // 5. Email
      final cellEmail = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cellEmail.value = TextCellValue(item.userEmail);
      cellEmail.cellStyle = baseStyle;

      // 6. Genere
      final cellGender = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cellGender.value = TextCellValue(item.userGender ?? '-');
      cellGender.cellStyle = centerStyle;

      // 7. Dipartimento
      final cellDept = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cellDept.value = TextCellValue(item.userDepartment ?? '-');
      cellDept.cellStyle = baseStyle;

      // 8. Istituzione
      final cellInst = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cellInst.value = TextCellValue(item.userInstitution ?? '-');
      cellInst.cellStyle = baseStyle;

      // 9. ID Corso
      final cellCourseId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cellCourseId.value = IntCellValue(item.courseId);
      cellCourseId.cellStyle = centerStyle;

      // 10. Titolo Corso
      final cellCourseTitle = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cellCourseTitle.value = TextCellValue(item.courseFullName);
      cellCourseTitle.cellStyle = baseStyle;

      // 11. Codice Corso
      final cellCourseCode = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cellCourseCode.value = TextCellValue(item.courseShortName);
      cellCourseCode.cellStyle = centerStyle;

      // 12. IDNumber Corso
      final cellCourseIdNum = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex));
      cellCourseIdNum.value = TextCellValue(item.courseIdNumber);
      cellCourseIdNum.cellStyle = centerStyle;

      // 13. Tipo Corso
      final cellCourseType = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex));
      cellCourseType.value = TextCellValue(item.courseType.toUpperCase());
      cellCourseType.cellStyle = centerStyle;

      // 14. Visibile
      final cellVis = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex));
      cellVis.value = TextCellValue(item.isCourseVisible ? 'Sì' : 'No');
      cellVis.cellStyle = centerStyle;

      // 15. Data Inizio
      final cellStart = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex));
      cellStart.cellStyle = centerStyle;
      if (item.courseStartDate != null) {
        cellStart.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(item.courseStartDate!));
      } else {
        cellStart.value = TextCellValue('N/D');
      }

      // 16. Data Fine
      final cellEnd = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex));
      cellEnd.cellStyle = centerStyle;
      if (item.courseEndDate != null) {
        cellEnd.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(item.courseEndDate!));
      } else {
        cellEnd.value = TextCellValue('N/D');
      }
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 14);
    sheet.setColumnWidth(1, 12);
    sheet.setColumnWidth(2, 28);
    sheet.setColumnWidth(3, 18);
    sheet.setColumnWidth(4, 26);
    sheet.setColumnWidth(5, 10);
    sheet.setColumnWidth(6, 20);
    sheet.setColumnWidth(7, 20);
    sheet.setColumnWidth(8, 12);
    sheet.setColumnWidth(9, 36);
    sheet.setColumnWidth(10, 18);
    sheet.setColumnWidth(11, 16);
    sheet.setColumnWidth(12, 14);
    sheet.setColumnWidth(13, 10);
    sheet.setColumnWidth(14, 20);
    sheet.setColumnWidth(15, 20);

    // Salvataggio File tramite FilePicker
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Iscrizioni_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Iscrizioni',
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
