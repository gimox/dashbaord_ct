import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;

class ProgressStatusExportItem {
  final String statusName;
  final int total;
  final int maleCount;
  final int femaleCount;
  final int unclassifiedCount;
  final int syncCount;
  final int asyncCount;
  final Map<String, int>? langCounts;

  ProgressStatusExportItem({
    required this.statusName,
    required this.total,
    required this.maleCount,
    required this.femaleCount,
    required this.unclassifiedCount,
    required this.syncCount,
    required this.asyncCount,
    this.langCounts,
  });
}

class ActiveUserDetailExportItem {
  final int userId;
  final String username;
  final String fullName;
  final String email;
  final String gender;
  final String language;
  final String status;
  final String courseType;
  final String coursesSummary;

  ActiveUserDetailExportItem({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.email,
    required this.gender,
    this.language = '-',
    required this.status,
    required this.courseType,
    required this.coursesSummary,
  });
}

class ActiveUsersProgressExcelExporter {
  /// Esporta la suddivisione per stato di avanzamento, gender e dettaglio utenti in formato Excel (.xlsx)
  static Future<String?> exportStats({
    required int totalActiveUsers,
    required List<ProgressStatusExportItem> items,
    List<ActiveUserDetailExportItem>? userDetails,
  }) async {
    final excel = Excel.createExcel();
    const sheetName = 'Riepilogo Avanzamento';

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
      'Stato Avanzamento',
      'Totale Utenti',
      '% su Utenti Attivi',
      'Maschile (M)',
      '% Maschile',
      'Femminile (F)',
      '% Femminile',
      'Non Classificato (N.C.)',
      '% Non Classificato',
      'Sync',
      '% Sync',
      'Async',
      '% Async',
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
      final totalPct = totalActiveUsers > 0 ? (total / totalActiveUsers * 100).toStringAsFixed(1) : '0.0';
      final malePct = total > 0 ? (item.maleCount / total * 100).toStringAsFixed(1) : '0.0';
      final femalePct = total > 0 ? (item.femaleCount / total * 100).toStringAsFixed(1) : '0.0';
      final unclassifiedPct = total > 0 ? (item.unclassifiedCount / total * 100).toStringAsFixed(1) : '0.0';
      final syncPct = total > 0 ? (item.syncCount / total * 100).toStringAsFixed(1) : '0.0';
      final asyncPct = total > 0 ? (item.asyncCount / total * 100).toStringAsFixed(1) : '0.0';

      // 0. Stato
      final cStatus = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cStatus.cellStyle = rowStyle;
      cStatus.value = TextCellValue(item.statusName);

      // 1. Totale Utenti
      final cTotal = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cTotal.cellStyle = centerStyle;
      cTotal.value = IntCellValue(total);

      // 2. % su Utenti Attivi
      final cTotalPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cTotalPct.cellStyle = centerStyle;
      cTotalPct.value = TextCellValue('$totalPct%');

      // 3. Maschile (M)
      final cMale = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cMale.cellStyle = centerStyle;
      cMale.value = IntCellValue(item.maleCount);

      // 4. % Maschile
      final cMalePct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cMalePct.cellStyle = centerStyle;
      cMalePct.value = TextCellValue('$malePct%');

      // 5. Femminile (F)
      final cFemale = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cFemale.cellStyle = centerStyle;
      cFemale.value = IntCellValue(item.femaleCount);

      // 6. % Femminile
      final cFemalePct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cFemalePct.cellStyle = centerStyle;
      cFemalePct.value = TextCellValue('$femalePct%');

      // 7. Non Classificato (N.C.)
      final cUnclass = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cUnclass.cellStyle = centerStyle;
      cUnclass.value = IntCellValue(item.unclassifiedCount);

      // 8. % Non Classificato
      final cUnclassPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cUnclassPct.cellStyle = centerStyle;
      cUnclassPct.value = TextCellValue('$unclassifiedPct%');

      // 9. Sync
      final cSync = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cSync.cellStyle = centerStyle;
      cSync.value = IntCellValue(item.syncCount);

      // 10. % Sync
      final cSyncPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cSyncPct.cellStyle = centerStyle;
      cSyncPct.value = TextCellValue('$syncPct%');

      // 11. Async
      final cAsync = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex));
      cAsync.cellStyle = centerStyle;
      cAsync.value = IntCellValue(item.asyncCount);

      // 12. % Async
      final cAsyncPct = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex));
      cAsyncPct.cellStyle = centerStyle;
      cAsyncPct.value = TextCellValue('$asyncPct%');

      // 13. Lingue (Pref. Corso)
      final langSummary = (item.langCounts != null && item.langCounts!.isNotEmpty)
          ? item.langCounts!.entries.map((e) => '${e.key}: ${e.value}').join(', ')
          : '-';
      final cLangs = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex));
      cLangs.cellStyle = rowStyle;
      cLangs.value = TextCellValue(langSummary);
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 24);
    sheet.setColumnWidth(1, 16);
    sheet.setColumnWidth(2, 20);
    sheet.setColumnWidth(3, 14);
    sheet.setColumnWidth(4, 14);
    sheet.setColumnWidth(5, 14);
    sheet.setColumnWidth(6, 14);
    sheet.setColumnWidth(7, 24);
    sheet.setColumnWidth(8, 20);
    sheet.setColumnWidth(9, 14);
    sheet.setColumnWidth(10, 14);
    sheet.setColumnWidth(11, 14);
    sheet.setColumnWidth(12, 14);
    sheet.setColumnWidth(13, 28);

    // Foglio 2: Dettaglio Utenti Attivi
    if (userDetails != null && userDetails.isNotEmpty) {
      final detailSheet = excel['Dettaglio Utenti Attivi'];
      final detailHeaders = [
        'ID Utente',
        'Username',
        'Nome e Cognome',
        'Email',
        'Genere',
        'Lingua',
        'Stato Avanzamento',
        'Tipologia Corso',
        'Corsi Associati',
      ];
      for (var colIndex = 0; colIndex < detailHeaders.length; colIndex++) {
        final cell = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0));
        cell.value = TextCellValue(detailHeaders[colIndex]);
        cell.cellStyle = headerStyle;
      }

      for (var i = 0; i < userDetails.length; i++) {
        final u = userDetails[i];
        final rowIndex = i + 1;
        final isEven = i % 2 == 0;
        final rowStyle = isEven ? rowEvenStyle : rowOddStyle;
        final centerStyle = isEven ? centerEvenStyle : centerOddStyle;

        // 0. ID Utente
        final cId = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
        cId.cellStyle = centerStyle;
        cId.value = IntCellValue(u.userId);

        // 1. Username
        final cUser = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
        cUser.cellStyle = rowStyle;
        cUser.value = TextCellValue(u.username);

        // 2. Nome e Cognome
        final cName = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
        cName.cellStyle = rowStyle;
        cName.value = TextCellValue(u.fullName);

        // 3. Email
        final cEmail = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
        cEmail.cellStyle = rowStyle;
        cEmail.value = TextCellValue(u.email);

        // 4. Genere
        final cGender = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
        cGender.cellStyle = centerStyle;
        cGender.value = TextCellValue(u.gender);

        // 5. Lingua
        final cLang = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
        cLang.cellStyle = centerStyle;
        cLang.value = TextCellValue(u.language);

        // 6. Stato Avanzamento
        final cStatus = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
        cStatus.cellStyle = centerStyle;
        cStatus.value = TextCellValue(u.status);

        // 7. Tipologia Corso
        final cType = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
        cType.cellStyle = centerStyle;
        cType.value = TextCellValue(u.courseType);

        // 8. Corsi Associati
        final cCourses = detailSheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
        cCourses.cellStyle = rowStyle;
        cCourses.value = TextCellValue(u.coursesSummary);
      }

      detailSheet.setColumnWidth(0, 14);
      detailSheet.setColumnWidth(1, 18);
      detailSheet.setColumnWidth(2, 26);
      detailSheet.setColumnWidth(3, 28);
      detailSheet.setColumnWidth(4, 12);
      detailSheet.setColumnWidth(5, 14);
      detailSheet.setColumnWidth(6, 20);
      detailSheet.setColumnWidth(7, 18);
      detailSheet.setColumnWidth(8, 45);
    }

    // Codifica file Excel
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Avanzamento_Utenti_Attivi_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva report Excel Avanzamento Utenti',
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
