import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/stat_mdl.dart';

class StatMdlExcelExporter {
  /// Esporta la lista di StatMdl in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportStatMdl(List<StatMdl> items) async {
    final excel = Excel.createExcel();
    const sheetName = 'Statistiche Moduli';

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
      'ID Utente',
      'Username',
      'Nome e Cognome',
      'Email',
      'Stato Corso',
      'Data Completamento Corso',
      'Primo Accesso',
      'Ultimo Accesso',
      'Genere',
      'Data di Nascita',
      'Lingua Corso',
      'Qualifica',
      'Organizzazione',
      'Tipo Modulo',
      'ID Modulo',
      'ID Corso',
      'Nome Corso',
      'Attività',
      'Data Completamento Modulo',
    ];

    // Scrittura Header
    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = headerStyle;
    }

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    // Scrittura Righe Dati
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final rowIndex = i + 1;
      final isEven = (i % 2 == 0);
      final baseStyle = isEven ? rowEvenStyle : rowOddStyle;
      final centerStyle = isEven ? centerEvenStyle : centerOddStyle;

      void writeCell(int col, CellValue val, [CellStyle? customStyle]) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex));
        cell.value = val;
        cell.cellStyle = customStyle ?? baseStyle;
      }

      writeCell(0, item.userId != null ? IntCellValue(item.userId!) : TextCellValue('-'), centerStyle);
      writeCell(1, TextCellValue(item.username ?? '-'));
      writeCell(2, TextCellValue(item.fullName.isNotEmpty ? item.fullName : '-'));
      writeCell(3, TextCellValue(item.email ?? '-'));
      writeCell(4, TextCellValue(item.statoCompletamentoCorso ?? '-'), centerStyle);
      writeCell(5, TextCellValue(item.dataCompletamentoCorso != null ? dateFormat.format(item.dataCompletamentoCorso!) : '-'), centerStyle);
      writeCell(6, TextCellValue(item.primoAccessoPiattaforma != null ? dateFormat.format(item.primoAccessoPiattaforma!) : '-'), centerStyle);
      writeCell(7, TextCellValue(item.ultimoAccessoPiattaforma != null ? dateFormat.format(item.ultimoAccessoPiattaforma!) : '-'), centerStyle);
      writeCell(8, TextCellValue(item.gender ?? '-'), centerStyle);
      writeCell(9, TextCellValue(item.dateOfBirthCnv ?? item.dateOfBirth ?? '-'), centerStyle);
      writeCell(10, TextCellValue(item.userCourseLang ?? '-'), centerStyle);
      writeCell(11, TextCellValue(item.qualification ?? '-'));
      writeCell(12, TextCellValue(item.membershipOrg ?? '-'));
      writeCell(13, TextCellValue(item.tipoModulo ?? '-'), centerStyle);
      writeCell(14, item.idModulo != null ? IntCellValue(item.idModulo!) : TextCellValue('-'), centerStyle);
      writeCell(15, item.idCorso != null ? IntCellValue(item.idCorso!) : TextCellValue('-'), centerStyle);
      writeCell(16, TextCellValue(item.nomeCorso ?? '-'));
      writeCell(17, TextCellValue(item.nomeAttivita ?? '-'));
      writeCell(18, TextCellValue(item.dataCompletamento != null ? dateFormat.format(item.dataCompletamento!) : '-'), centerStyle);
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 12);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 22);
    sheet.setColumnWidth(3, 26);
    sheet.setColumnWidth(4, 16);
    sheet.setColumnWidth(5, 22);
    sheet.setColumnWidth(6, 20);
    sheet.setColumnWidth(7, 20);
    sheet.setColumnWidth(8, 10);
    sheet.setColumnWidth(9, 14);
    sheet.setColumnWidth(10, 12);
    sheet.setColumnWidth(11, 20);
    sheet.setColumnWidth(12, 20);
    sheet.setColumnWidth(13, 14);
    sheet.setColumnWidth(14, 12);
    sheet.setColumnWidth(15, 12);
    sheet.setColumnWidth(16, 32);
    sheet.setColumnWidth(17, 30);
    sheet.setColumnWidth(18, 22);

    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Statistiche_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Statistiche Moduli',
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
