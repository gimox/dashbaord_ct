import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as uio;
import '../../sync/models/user.dart';

class UserExcelExporter {
  static Future<String?> exportUsers(List<User> users) async {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultSheet, 'Utenti CyberProTrain');
    final sheet = excel['Utenti CyberProTrain'];

    // --- Stili Base ---
    // Intestazione ingrandita (13pt in grassetto su blu scuro)
    final headerStyle = CellStyle(
      bold: true,
      fontSize: 13,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#1E3A8A'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Righe Normali (Pari / Dispari)
    final evenRowStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      verticalAlign: VerticalAlign.Center,
    );

    final oddRowStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      verticalAlign: VerticalAlign.Center,
    );

    final centerEvenStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final centerOddStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Stili per Confermato = No (Rosso)
    final confirmedNoEvenStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#DC2626'), // Rosso
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final confirmedNoOddStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#DC2626'), // Rosso
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Stili per Genere Maschio (Azzurro)
    final genderMEvenStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#0284C7'), // Azzurro
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final genderMOddStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#0284C7'), // Azzurro
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Stili per Genere Femmina (Rosa)
    final genderFEvenStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#DB2777'), // Rosa
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final genderFOddStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#DB2777'), // Rosa
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Stili compatibili per DateCellValue (Data di Nascita)
    final dateEvenStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      numberFormat: NumFormat.defaultDate,
    );

    final dateOddStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      numberFormat: NumFormat.defaultDate,
    );

    // Stili compatibili per DateTimeCellValue (Primo / Ultimo Accesso)
    final dateTimeEvenStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      numberFormat: NumFormat.defaultDateTime,
    );

    final dateTimeOddStyle = CellStyle(
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#1E293B'),
      backgroundColorHex: ExcelColor.fromHexString('#F8FAFC'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      numberFormat: NumFormat.defaultDateTime,
    );

    // --- Stili per RIGA SOSPESA (Evidenziata tutta in Rosso) ---
    final suspendedBg = ExcelColor.fromHexString('#FEE2E2'); // Sfondo rosso chiaro
    final suspendedText = ExcelColor.fromHexString('#991B1B'); // Testo rosso scuro leggibile

    final suspendedTextStyle = CellStyle(
      fontSize: 10,
      fontColorHex: suspendedText,
      backgroundColorHex: suspendedBg,
      verticalAlign: VerticalAlign.Center,
    );

    final suspendedCenterStyle = CellStyle(
      fontSize: 10,
      fontColorHex: suspendedText,
      backgroundColorHex: suspendedBg,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final suspendedStatusStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#B91C1C'),
      backgroundColorHex: ExcelColor.fromHexString('#FECACA'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final suspendedGenderMStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#0369A1'), // Azzurro su sfondo rosso
      backgroundColorHex: suspendedBg,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final suspendedGenderFStyle = CellStyle(
      bold: true,
      fontSize: 10,
      fontColorHex: ExcelColor.fromHexString('#BE185D'), // Rosa/magenta su sfondo rosso
      backgroundColorHex: suspendedBg,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final suspendedDateStyle = CellStyle(
      fontSize: 10,
      fontColorHex: suspendedText,
      backgroundColorHex: suspendedBg,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      numberFormat: NumFormat.defaultDate,
    );

    final suspendedDateTimeStyle = CellStyle(
      fontSize: 10,
      fontColorHex: suspendedText,
      backgroundColorHex: suspendedBg,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      numberFormat: NumFormat.defaultDateTime,
    );

    // Intestazioni Colonne direttamente a riga 0
    final headers = [
      'ID',
      'Username',
      'Cognome',
      'Nome',
      'Nome Completo',
      'Email',
      'Dipartimento',
      'Stato Account',
      'Confermato',
      'Metodo Auth',
      'Genere',
      'Data di Nascita',
      'Età',
      'Membership Organization',
      'Lingua Corso',
      'Edizione',
      'Primo Accesso',
      'Ultimo Accesso',
    ];

    const headerRow = 0;
    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: headerRow));
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = headerStyle;
    }

    // Popolamento Righe Utenti a partire dalla riga 1
    var currentRow = headerRow + 1;
    for (final u in users) {
      final isSuspended = (u.suspended == true);
      final isEven = (currentRow % 2 == 0);

      // Determinazione dati testuali
      final idStr = '#${u.id}';
      final usernameStr = u.username ?? '-';
      final lastnameStr = u.lastname ?? '-';
      final firstnameStr = u.firstname ?? '-';
      final fullnameStr = u.fullname?.trim().isNotEmpty == true
          ? u.fullname!
          : '${u.firstname ?? ""} ${u.lastname ?? ""}'.trim();
      final emailStr = u.email ?? '-';
      final deptStr = u.department ?? '-';
      final statusStr = isSuspended ? 'Sospeso' : 'Attivo';

      // Confermato
      final isConfirmed = (u.confirmed == true);
      final confirmedStr = isConfirmed ? 'Sì' : 'No';

      final authStr = u.auth ?? '-';

      // Genere
      final rawGender = _getCustomFieldValue(u, ['gender', 'sesso', 'genere'])?.trim() ?? '-';
      final lowerGender = rawGender.toLowerCase();
      final isMale = lowerGender == 'm' || lowerGender.startsWith('masch') || lowerGender == 'male';
      final isFemale = lowerGender == 'f' || lowerGender.startsWith('femm') || lowerGender == 'female';

      // Data di Nascita ed Età calcolata (da modello nativo)
      final parsedDob = u.effectiveDob;
      final age = u.age;

      // Date valide Excel per Data di Nascita, Primo Accesso e Ultimo Accesso
      final CellValue dobCellValue;
      if (parsedDob != null) {
        dobCellValue = DateCellValue(
          year: parsedDob.year,
          month: parsedDob.month,
          day: parsedDob.day,
        );
      } else {
        final rawFallback = _getCustomFieldValue(u, ['birth', 'nascita', 'dob'])?.trim();
        dobCellValue = TextCellValue((rawFallback != null && rawFallback.isNotEmpty) ? rawFallback : '-');
      }

      final CellValue firstAccessCellValue;
      if (u.firstaccess != null && u.firstaccess! > 0) {
        final dt = DateTime.fromMillisecondsSinceEpoch(u.firstaccess! * 1000);
        firstAccessCellValue = DateTimeCellValue.fromDateTime(dt);
      } else {
        firstAccessCellValue = TextCellValue('-');
      }

      final CellValue lastAccessCellValue;
      if (u.lastaccess != null && u.lastaccess! > 0) {
        final dt = DateTime.fromMillisecondsSinceEpoch(u.lastaccess! * 1000);
        lastAccessCellValue = DateTimeCellValue.fromDateTime(dt);
      } else {
        lastAccessCellValue = TextCellValue('-');
      }

      final CellValue ageCellValue = (age != null) ? IntCellValue(age) : TextCellValue('-');

      // Altri campi personalizzati
      final orgStr = _getCustomFieldValue(u, ['membership', 'organization', 'organizzaz']) ?? (u.department ?? '-');
      final langStr = _getCustomFieldValue(u, ['course lang', 'course_lang', 'prefcourselang', 'pref_course_lang', 'lang']) ?? (u.lang ?? '-');
      final editionStr = _getCustomFieldValue(u, ['edition', 'edizione']) ?? '-';

      // Assegnazione Stili: Se sospeso, TUTTA la riga è evidenziata di rosso
      final CellStyle textStyle;
      final CellStyle centerStyle;
      final CellStyle statusStyle;
      final CellStyle confirmedStyle;
      final CellStyle genderStyle;
      final CellStyle dobStyle;
      final CellStyle firstAccessStyle;
      final CellStyle lastAccessStyle;

      if (isSuspended) {
        textStyle = suspendedTextStyle;
        centerStyle = suspendedCenterStyle;
        statusStyle = suspendedStatusStyle;
        confirmedStyle = isConfirmed
            ? suspendedCenterStyle
            : CellStyle(
                bold: true,
                fontSize: 10,
                fontColorHex: ExcelColor.fromHexString('#B91C1C'),
                backgroundColorHex: suspendedBg,
                horizontalAlign: HorizontalAlign.Center,
                verticalAlign: VerticalAlign.Center,
              );
        genderStyle = isMale
            ? suspendedGenderMStyle
            : isFemale
                ? suspendedGenderFStyle
                : suspendedCenterStyle;
        dobStyle = (dobCellValue is DateCellValue) ? suspendedDateStyle : suspendedCenterStyle;
        firstAccessStyle = (firstAccessCellValue is DateTimeCellValue) ? suspendedDateTimeStyle : suspendedCenterStyle;
        lastAccessStyle = (lastAccessCellValue is DateTimeCellValue) ? suspendedDateTimeStyle : suspendedCenterStyle;
      } else {
        textStyle = isEven ? evenRowStyle : oddRowStyle;
        centerStyle = isEven ? centerEvenStyle : centerOddStyle;
        statusStyle = centerStyle;
        confirmedStyle = isConfirmed
            ? centerStyle
            : (isEven ? confirmedNoEvenStyle : confirmedNoOddStyle);
        genderStyle = isMale
            ? (isEven ? genderMEvenStyle : genderMOddStyle)
            : isFemale
                ? (isEven ? genderFEvenStyle : genderFOddStyle)
                : centerStyle;
        dobStyle = (dobCellValue is DateCellValue)
            ? (isEven ? dateEvenStyle : dateOddStyle)
            : centerStyle;
        firstAccessStyle = (firstAccessCellValue is DateTimeCellValue)
            ? (isEven ? dateTimeEvenStyle : dateTimeOddStyle)
            : centerStyle;
        lastAccessStyle = (lastAccessCellValue is DateTimeCellValue)
            ? (isEven ? dateTimeEvenStyle : dateTimeOddStyle)
            : centerStyle;
      }

      final rowValues = [
        (TextCellValue(idStr), centerStyle),
        (TextCellValue(usernameStr), textStyle),
        (TextCellValue(lastnameStr), textStyle),
        (TextCellValue(firstnameStr), textStyle),
        (TextCellValue(fullnameStr), textStyle),
        (TextCellValue(emailStr), textStyle),
        (TextCellValue(deptStr), textStyle),
        (TextCellValue(statusStr), statusStyle),
        (TextCellValue(confirmedStr), confirmedStyle),
        (TextCellValue(authStr), centerStyle),
        (TextCellValue(rawGender), genderStyle),
        (dobCellValue, dobStyle),
        (ageCellValue, centerStyle),
        (TextCellValue(orgStr), textStyle),
        (TextCellValue(langStr), centerStyle),
        (TextCellValue(editionStr), centerStyle),
        (firstAccessCellValue, firstAccessStyle),
        (lastAccessCellValue, lastAccessStyle),
      ];

      for (var col = 0; col < rowValues.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: currentRow));
        cell.value = rowValues[col].$1;
        cell.cellStyle = rowValues[col].$2;
      }

      currentRow++;
    }

    // Larghezza Colonne Ottimizzata
    final columnWidths = [
      10.0, // ID
      18.0, // Username
      18.0, // Cognome
      18.0, // Nome
      24.0, // Nome Completo
      28.0, // Email
      22.0, // Dipartimento
      14.0, // Stato Account
      13.0, // Confermato
      13.0, // Metodo Auth
      14.0, // Genere
      16.0, // Data di Nascita (Date format)
      10.0, // Età
      26.0, // Organization
      14.0, // Lingua Corso
      16.0, // Edizione
      20.0, // Primo Accesso (DateTime format)
      20.0, // Ultimo Accesso (DateTime format)
    ];

    for (var col = 0; col < columnWidths.length; col++) {
      sheet.setColumnWidth(col, columnWidths[col]);
    }

    // Esportazione File
    final bytes = excel.encode();
    if (bytes == null) return null;
    final uint8List = Uint8List.fromList(bytes);

    final fileName = 'CyberProTrain_Users_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Salva esportazione Excel Utenti',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: uint8List,
    );

    // Su desktop non-web, se l'utente seleziona un percorso, assicuriamoci che il file sia scritto
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

  static String? _getCustomFieldValue(User u, List<String> keywords) {
    if (u.customfields == null) return null;
    for (final cf in u.customfields!) {
      final name = (cf.name ?? '').toLowerCase();
      final shortname = (cf.shortname ?? '').toLowerCase();
      for (final kw in keywords) {
        if (name.contains(kw) || shortname.contains(kw)) {
          final val = cf.displayvalue?.trim().isNotEmpty == true
              ? cf.displayvalue
              : cf.value?.trim().isNotEmpty == true
                  ? cf.value
                  : null;
          if (val != null) return val;
        }
      }
    }
    return null;
  }
}
