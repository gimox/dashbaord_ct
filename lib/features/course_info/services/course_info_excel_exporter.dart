import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/course_info.dart';

class CourseInfoExcelExporter {
  /// Esporta la lista di CourseInfo (sezioni e moduli) in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportCourseInfo(List<CourseInfo> items) async {
    final excel = Excel.createExcel();
    const sheetName = 'Course Info & Moduli';

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
      'ID Sezione',
      'Nome Sezione',
      'Numero Sezione',
      'Visibile',
      'Utente Visibile',
      'N. Moduli',
      'Nomi Moduli',
      'Tipi Moduli',
      'Componente',
      'Item ID',
      'Sommario',
    ];

    for (int c = 0; c < headers.length; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0));
      cell.value = TextCellValue(headers[c]);
      cell.cellStyle = headerStyle;
    }

    // Riempimento Dati
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final rowIndex = i + 1;
      final isHidden = item.visible == 0;
      final baseStyle = isHidden ? hiddenRowStyle : (i.isEven ? rowEvenStyle : rowOddStyle);
      final centerStyle = isHidden ? hiddenRowStyle : (i.isEven ? centerEvenStyle : centerOddStyle);

      // 0. ID Sezione
      final cellId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellId.value = IntCellValue(item.id);
      cellId.cellStyle = centerStyle;

      // 1. Nome Sezione
      final cellName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellName.value = TextCellValue(item.name ?? '-');
      cellName.cellStyle = baseStyle;

      // 2. Numero Sezione
      final cellSection = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellSection.value = item.section != null ? IntCellValue(item.section!) : TextCellValue('-');
      cellSection.cellStyle = centerStyle;

      // 3. Visibile
      final cellVis = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellVis.value = TextCellValue(item.visible == 1 ? 'Sì' : 'No');
      cellVis.cellStyle = centerStyle;

      // 4. Utente Visibile
      final cellUserVis = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cellUserVis.value = TextCellValue(item.uservisible == true ? 'Sì' : 'No');
      cellUserVis.cellStyle = centerStyle;

      // 5. N. Moduli
      final modulesCount = item.modules?.length ?? 0;
      final cellModCount = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cellModCount.value = IntCellValue(modulesCount);
      cellModCount.cellStyle = centerStyle;

      // 6. Nomi Moduli
      final moduleNames = item.modules?.map((m) => m.name ?? '').where((n) => n.isNotEmpty).join(', ') ?? '-';
      final cellModNames = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cellModNames.value = TextCellValue(moduleNames.isEmpty ? '-' : moduleNames);
      cellModNames.cellStyle = baseStyle;

      // 7. Tipi Moduli
      final moduleTypes = item.modules?.map((m) => m.modname ?? '').where((t) => t.isNotEmpty).toSet().join(', ') ?? '-';
      final cellModTypes = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cellModTypes.value = TextCellValue(moduleTypes.isEmpty ? '-' : moduleTypes);
      cellModTypes.cellStyle = baseStyle;

      // 8. Componente
      final cellComp = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cellComp.value = TextCellValue(item.component ?? '-');
      cellComp.cellStyle = centerStyle;

      // 9. Item ID
      final cellItem = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cellItem.value = item.itemid != null ? IntCellValue(item.itemid!) : TextCellValue('-');
      cellItem.cellStyle = centerStyle;

      // 10. Sommario
      final cleanSummary = (item.summary ?? '').replaceAll(RegExp(r'<[^>]*>'), '').trim();
      final cellSummary = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex));
      cellSummary.value = TextCellValue(cleanSummary.isEmpty ? '-' : cleanSummary);
      cellSummary.cellStyle = baseStyle;
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 12);
    sheet.setColumnWidth(1, 26);
    sheet.setColumnWidth(2, 14);
    sheet.setColumnWidth(3, 12);
    sheet.setColumnWidth(4, 14);
    sheet.setColumnWidth(5, 12);
    sheet.setColumnWidth(6, 40);
    sheet.setColumnWidth(7, 24);
    sheet.setColumnWidth(8, 16);
    sheet.setColumnWidth(9, 12);
    sheet.setColumnWidth(10, 36);

    // Salvataggio File tramite FilePicker
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_CourseInfo_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Course Info',
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
