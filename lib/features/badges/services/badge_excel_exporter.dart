import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/badge_user.dart';
import '../../sync/models/user.dart';

class BadgeExcelExporter {
  /// Esporta la lista dei badge assegnati agli utenti in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportBadges(
    List<BadgeUser> badges, [
    Map<String, User>? usersMap,
  ]) async {
    final excel = Excel.createExcel();
    const sheetName = 'Badges CyberProTrain';

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
      'Nome e Cognome Utente',
      'Email Utente',
      'Badge / Certificazione',
      'Codice',
      'Data Rilascio (Issued On)',
      'Ultimo Sync',
    ];

    for (int c = 0; c < headers.length; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0));
      cell.value = TextCellValue(headers[c]);
      cell.cellStyle = headerStyle;
    }

    // Riempimento Dati
    for (int i = 0; i < badges.length; i++) {
      final b = badges[i];
      final rowIndex = i + 1;
      final baseStyle = i.isEven ? rowEvenStyle : rowOddStyle;
      final centerStyle = i.isEven ? centerEvenStyle : centerOddStyle;

      final u = usersMap?[b.email?.trim().toLowerCase()];
      String userName = 'N/D';
      if (u != null) {
        if (u.fullname != null && u.fullname!.trim().isNotEmpty) {
          userName = u.fullname!.trim();
        } else if ((u.firstname != null && u.firstname!.isNotEmpty) || (u.lastname != null && u.lastname!.isNotEmpty)) {
          userName = '${u.firstname ?? ''} ${u.lastname ?? ''}'.trim();
        }
      }

      // 1. Nome e Cognome Utente
      final cellName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellName.value = TextCellValue(userName);
      cellName.cellStyle = baseStyle;

      // 2. Email Utente
      final cellEmail = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellEmail.value = TextCellValue(b.email ?? '');
      cellEmail.cellStyle = baseStyle;

      // 3. Badge
      final cellBadge = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellBadge.value = TextCellValue(b.badge ?? '');
      cellBadge.cellStyle = baseStyle;

      // 4. Codice
      final cellCode = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellCode.value = TextCellValue(b.code ?? '');
      cellCode.cellStyle = centerStyle;

      // 5. Data Rilascio
      final cellIssued = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cellIssued.cellStyle = centerStyle;
      if (b.issuedOnDate != null) {
        cellIssued.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(b.issuedOnDate!));
      } else {
        cellIssued.value = TextCellValue(b.issuedOn ?? 'N/D');
      }

      // 6. Ultimo Sync
      final cellSync = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cellSync.cellStyle = centerStyle;
      if (b.lastSyncedAt != null) {
        cellSync.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(b.lastSyncedAt!));
      } else {
        cellSync.value = TextCellValue('N/D');
      }
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 30);
    sheet.setColumnWidth(1, 35);
    sheet.setColumnWidth(2, 40);
    sheet.setColumnWidth(3, 18);
    sheet.setColumnWidth(4, 25);
    sheet.setColumnWidth(5, 20);

    // Salvataggio File tramite FilePicker
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Badges_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Badges',
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
