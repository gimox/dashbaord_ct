import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../models/dg_cnect_kpi.dart';

class DgCnectExcelExporter {
  static const String defaultTemplatePath =
      'assets/report/DG-CNECT KPIs Dashboard.xlsx';

  /// Esporta esattamente il file Excel DG-CNECT popola la Colonna F (WP3 - TIM)
  /// preservando al 100% tutte le formattazioni, formule, fogli, stili e grafiche originali.
  static Future<String?> exportReport({
    required List<DgCnectKpiItem> kpiItems,
  }) async {
    // 1. Caricamento del template Excel originale
    List<int> templateBytes;
    try {
      final byteData = await rootBundle.load(defaultTemplatePath);
      templateBytes = byteData.buffer.asUint8List();
    } catch (_) {
      if (!kIsWeb) {
        final localFile = uio.File(defaultTemplatePath);
        if (await localFile.exists()) {
          templateBytes = await localFile.readAsBytes();
        } else {
          throw Exception('Template Excel DG-CNECT non trovato in $defaultTemplatePath');
        }
      } else {
        throw Exception('Impossibile caricare il template Excel DG-CNECT');
      }
    }

    // 2. Decodifica archivio OpenXML (ZIP)
    final archive = ZipDecoder().decodeBytes(templateBytes);
    final sheetFile = archive.findFile('xl/worksheets/sheet1.xml');
    if (sheetFile == null) {
      throw Exception('Struttura del foglio Excel non conforme (sheet1.xml mancante).');
    }

    var sheetXml = utf8.decode(sheetFile.content as List<int>);

    // Mappa riga -> valore
    final Map<int, dynamic> rowValues = {
      for (final item in kpiItems) item.row: item.value,
    };

    // 3. Sostituzione mirata dei valori nella colonna F
    for (final entry in rowValues.entries) {
      final row = entry.key;
      final val = entry.value;
      if (val == null) continue;

      final cellRef = 'F$row';
      final formattedVal = (val is double)
          ? val.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')
          : val.toString();

      // Cerca il nodo <c ... r="F..." ...> e aggiorna o inserisce <v>val</v>
      final cellRegex = RegExp(
        r'(<c\b[^>]*\br="' + cellRef + r'"[^>]*>)(?:<v>[^<]*</v>)?(.*?)(</c>)',
      );

      if (cellRegex.hasMatch(sheetXml)) {
        sheetXml = sheetXml.replaceFirstMapped(cellRegex, (match) {
          final openTag = match.group(1)!;
          final middleContent = match.group(2) ?? '';
          final closeTag = match.group(3)!;
          return '$openTag<v>$formattedVal</v>$middleContent$closeTag';
        });
      }
    }

    // 4. Ricostruzione dell'archivio Excel mantenendo tutti gli altri file intatti
    final newArchive = Archive();
    final updatedSheetBytes = utf8.encode(sheetXml);

    for (final file in archive.files) {
      if (file.name == 'xl/worksheets/sheet1.xml') {
        newArchive.addFile(
          ArchiveFile(file.name, updatedSheetBytes.length, updatedSheetBytes),
        );
      } else {
        newArchive.addFile(file);
      }
    }

    final outBytes = ZipEncoder().encode(newArchive);
    if (outBytes == null) {
      throw Exception('Errore durante la compressione del file Excel.');
    }
    final uint8List = Uint8List.fromList(outBytes);

    // 5. Salvataggio cross-platform del file
    final now = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'DG-CNECT_KPIs_Dashboard_WP3_$now.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva Report DG-CNECT KPIs Dashboard (WP3)',
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
