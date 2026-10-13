import 'package:flutter/foundation.dart' hide Category;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/category.dart';

class CategoryExcelExporter {
  /// Esporta la lista delle categorie in un file Excel (.xlsx) con formattazione istituzionale
  static Future<String?> exportCategories(List<Category> categories) async {
    final excel = Excel.createExcel();
    const sheetName = 'Categorie CyberProTrain';

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
      'Codice (IDNumber)',
      'Nome Categoria',
      'Visibile',
      'N° Corsi',
      'Livello (Depth)',
      'Parent ID',
      'Path',
      'Ultima Modifica',
      'Descrizione',
    ];

    for (int c = 0; c < headers.length; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0));
      cell.value = TextCellValue(headers[c]);
      cell.cellStyle = headerStyle;
    }

    // Riempimento Dati
    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final rowIndex = i + 1;
      final isHidden = cat.visible == 0;
      final baseStyle = isHidden ? hiddenRowStyle : (i.isEven ? rowEvenStyle : rowOddStyle);
      final centerStyle = isHidden ? hiddenRowStyle : (i.isEven ? centerEvenStyle : centerOddStyle);


      // 1. ID
      final cellId = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellId.value = IntCellValue(cat.id);
      cellId.cellStyle = centerStyle;

      // 2. IDNumber
      final cellIdNum = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellIdNum.value = TextCellValue(cat.idnumber ?? '');
      cellIdNum.cellStyle = centerStyle;

      // 3. Nome
      final cellName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellName.value = TextCellValue(cat.name ?? '');
      cellName.cellStyle = baseStyle;

      // 4. Visibile
      final cellVis = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellVis.value = TextCellValue(cat.isVisible ? 'Sì' : 'No');
      cellVis.cellStyle = centerStyle;

      // 5. N° Corsi
      final cellCount = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex));
      cellCount.value = IntCellValue(cat.coursecount ?? 0);
      cellCount.cellStyle = centerStyle;

      // 6. Depth
      final cellDepth = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex));
      cellDepth.value = IntCellValue(cat.depth ?? 0);
      cellDepth.cellStyle = centerStyle;

      // 7. Parent
      final cellParent = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex));
      cellParent.value = IntCellValue(cat.parent ?? 0);
      cellParent.cellStyle = centerStyle;

      // 8. Path
      final cellPath = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex));
      cellPath.value = TextCellValue(cat.path ?? '');
      cellPath.cellStyle = baseStyle;

      // 9. Data Ultima Modifica
      final cellMod = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex));
      cellMod.cellStyle = centerStyle;
      if (cat.timemodifiedDate != null) {
        cellMod.value = TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(cat.timemodifiedDate!));
      } else {
        cellMod.value = TextCellValue('N/D');
      }

      // 10. Descrizione Pulita
      final cellDesc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex));
      cellDesc.value = TextCellValue(cat.plainDescription);
      cellDesc.cellStyle = baseStyle;
    }

    // Larghezze colonne
    sheet.setColumnWidth(0, 10);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 32);
    sheet.setColumnWidth(3, 12);
    sheet.setColumnWidth(4, 14);
    sheet.setColumnWidth(5, 14);
    sheet.setColumnWidth(6, 14);
    sheet.setColumnWidth(7, 16);
    sheet.setColumnWidth(8, 20);
    sheet.setColumnWidth(9, 40);

    // Salvataggio File tramite FilePicker (compatibile Sandbox macOS e Web)
    final fileBytes = excel.encode();
    if (fileBytes == null) return null;
    final uint8List = Uint8List.fromList(fileBytes);

    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'CyberProTrain_Categories_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Categorie',
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
