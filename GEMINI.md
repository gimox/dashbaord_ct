# CRITICAL TOKEN-SAVING INSTRUCTIONS
- Always be extremely concise. Restrict all chat answers to the core code fix.
- NEVER generate final walkthroughs, summaries, or explanations unless explicitly requested.
- DO NOT launch autonomous sub-agents to scan the workspace without asking for my confirmation first.
- Stop execution immediately after writing the required code block.
- non mostrare il codice della modifica effettuata in chat (anche se richiesto). Fai solo una breve sintesi del task completato.
- **REGOLA MANDATORIA SYNC AUTOMATICO:** Ogni volta che viene richiesto di creare/aggiungere un database Isar con relativo modello di entità, DEVE essere implementato e integrato AUTOMATICAMENTE anche tutto il modulo di sincronizzazione (Sync API + CTA in `sync_view.dart` + tracciamento `last<Entity>SyncDate` in `AppSettings` + reset in `db_settings_view.dart`), senza necessità di richiederlo esplicitamente.


# LINEE GUIDA
Segui il file GEMINI_TEMPLATE.MD come guida per creare la struttura base di un'app.


# CyberProTrain Admin - System Rules & Context

## 1. TECH STACK & ARCHITECTURE
- **Framework:** Flutter (Desktop macOS/Windows/Linux & Web App target).
- **Web & Desktop Constraints:**
  - NEVER use `dart:io` directly in web-exposed files (causes Web crash). Use `package:universal_io` or cross-platform plugins.
  - Check platform conditionally (`kIsWeb`, `Platform.isWindows`, etc.).
  - Desktop window configuration: `window_manager` (size 1360x800, min 1000x700, centered).
- **Navigation:** GoRouter (Declarative routing, strongly typed paths in `lib/core/navigation`).
- **State Management:** Riverpod (`flutter_riverpod`, `StateNotifierProvider`, singleton provider overrides).
- **Database:** Isar Database (`package:isar_community`, `isar_community_flutter_libs`). Singleton instance injected via `isarProvider`. Gestione difensiva con `try-catch` su deserializzazioni per proteggere l'avvio da disallineamenti di schema in sviluppo.
- **Regola DB & Sync Inseparabili:** Ogni modello/collezione Isar creata include SEMPRE contestualmente:
  1. Registrazione schema e try-catch difensivo in `main.dart`.
  2. Conteggio e reset tabella in `db_settings_view.dart`.
  3. Campo `last<EntityPlural>SyncDate` in `AppSettings`.
  4. Card di sincronizzazione e chiamata API di sync (fetch + upsert) in `sync_view.dart`.
- **UI:** Material 3. Enterprise dashboard, tema istituzionale (`AppTheme.primaryBlue`, `AppTheme.accentRed`).
- **Code Standards:** Clean Architecture (Core, Features, Settings, Sync). Separazione netta tra logica di business e presentazione.

## 2. UI/UX & RESPONSIVENESS REQUIREMENTS
- **Responsiveness:** Ogni schermata e componente DEVE usare layout adattivi (`LayoutBuilder`, `MediaQuery`).
- **Sidebar Animata:** Gestione rigorosa dei vincoli: evitare `OverflowBox` non vincolati dentro `Column`; usare `FittedBox(fit: BoxFit.scaleDown)` e padding interni agli `Expanded` per prevenire overflow durante le transizioni di larghezza (76px ↔ 240px).
- **Navigazione Laterale:**
  - `Home`: vista principale della dashboard.
  - `Impostazioni`: menu genitore comprimibile con sotto-menu dedicati:
    - `Sync`: pannello sincronizzazione entità.
    - `Rete & Proxy`: configurazione proxy aziendale, PAC, SSL inspection.
    - `API SERVER`: parametri endpoint, autenticazione e test di connessione.
    - `Database`: monitoraggio e reset tabelle Isar.

## 3. MODULI FUNZIONALI ATTIVI
- **Rete & Proxy:** `ProxyService` con override globale di `HttpOverrides`, auto-detect di sistema (scutil / reg), bypass SSL (`bypassSslVerification`) e supporto credenziali.
- **API SERVER:** Gestione parametri `apiBaseUrl`, `apiUsername`, `apiPassword` e `apiTestEndpoint` persistiti in Isar. Chiamate HTTP di verifica con autenticazione Basic e parsing strutturato dell'array `elements`.
- **Sincronizzazione (Sync):**
  - Modello `User` con embedded `CustomField` indicizzato su Isar.
  - CTA di sincronizzazione `Users` con data ultimo sync persistita in `AppSettings.lastUsersSyncDate`.
  - Upsert massivo (`putAll`) nel database locale Isar da endpoint API.

## 4. BUILD & RELEASE CI/CD
- GitHub Actions workflow in `.github/workflows/desktop_release.yml` per packaging automatico DMG (macOS) e ZIP (Windows) su tag di release.
- Entitlements macOS sandbox configurati per consentire connessioni di rete in uscita (`com.apple.security.network.client`).

## 5. STANDARD TEMPLATE VISTE ENTITÀ (TEMPLATE GUIDA: USERS)
Tutte le future schermate tabellari/entità (es. Courses, Modules, Certifications, etc.) DEVONO seguire rigorosamente l'architettura e i pattern UX stabiliti in `UsersListView`:

### A. Layout Schermata & Header
- **Top Header:** Titolo vista grande + sottotitolo descrittivo. Nessun badge ingombrante in cima (i totali vanno nel footer).
- **Barra Ricerca:** `TextField` con icona search e clear integrato, espansa con `Expanded`.
- **Pulsante Filtri Avanzati:** Con badge contatore filtri attivi; deve scomparire fluidamente (`AnimatedSize`) quando il pannello laterale è aperto per lasciare spazio alla ricerca.
- **Chips Filtri Attivi:** Barra dinamica (`Wrap`) sotto la search bar con chip per ogni filtro attivo (con 'x' per revoca singola) e pulsante rapido "Cancella tutti" se > 1 filtro attivo.

### B. Tabella Dati (Enterprise Dashboard Design - No Excel-like)
- **Container:** Box con bordi arrotondati (`borderRadius: 14`), bordo sottile e leggera ombra (`elevation: 0`, box shadow morbida).
- **Nessuna griglia rigida Excel:** `border: null`, solo separatori orizzontali sottili (`dividerThickness: 1`).
- **Header Tabella:** Sfondo grigio tenue (`Color(0xFFF8FAFC)`), testo semi-bold con letter-spacing.
- **Spaziatura Righe:** Altezza confortevole (`dataRowMinHeight: 52`, `dataRowMaxHeight: 58`), sfondo bianco con highlight blu trasparente al passaggio del mouse (`hover`).
- **Colonna Azioni:** All'inizio (prima di ID) con icona visibilità in container arrotondato.
- **Colonna ID:** Stilizzata in badge compatto mono (`#123`).
- **Cella Entità Principale:** Composta da Avatar circolare con iniziale/colore + Nome in risalto + identificatore secondario (es. `@username` o codice) in grigio sotto.
- **Badge di Stato:** Pill arrotondate con indicatore a pallino colorato (verde Attivo, rosso Sospeso, etc.) e icone di stato per booleani.
- **Ordinamento:** Supporto ordinamento colonne (`onSort`) sincronizzato con `_sortColumnIndex` e `_sortAscending`.

### C. Paginazione & Footer Responsive
- **Paginazione:** Paginazione standard a 50 elementi per pagina (`_pageSize = 50`).
- **LayoutBuilder Obbligatorio:** Il footer DEVE usare `LayoutBuilder`. Se la larghezza scende (< 560px), passa automaticamente a colonna verticale per evitare errori `RenderFlex overflow`.
- **Conteggio Completo:** Mostrare nel footer: `Mostrati X - Y di Z utenti` oppure `Mostrati X - Y di Z (filtrati da Totale totali)`.
- **Controlli:** Pulsanti Prima pagina, Pagina precedente, Badge pagina `X / Y`, Pagina successiva, Ultima pagina.

### D. Drawer Laterale Filtri Avanzati
- **Animazione Fluida:** Apertura/chiusura a scorrimento con `AnimatedContainer` (280ms, `Curves.fastOutSlowIn`), `ClipRect` e `OverflowBox(alignment: Alignment.topRight)` da 340px a 0px.
- **Header:** Gradiente blu sfumato istituzionale (`0xFF0F2027` ➔ `0xFF203A43` ➔ `0xFF2C5364`), badge contatore e pulsante chiusura.
- **Filtri Booleani (True/False):** Pulsanti a 3 segmenti `[ Tutti ]  [ True ]  [ False ]` (NON usare menu a tendina select).
- **Filtri Multipli & Liste > 10:** Selettore multi-selezione con chip rimovibili e finestra modale dotata di barra di ricerca in tempo reale, conteggio e tasti "Seleziona visibili" / "Deseleziona tutti".
- **Filtri Data:** Selettori range "Da" / "A" con date picker e clear rapido.
- **Footer:** Pulsante "Azzera" (attivo solo se ci sono filtri) e "Chiudi".

### E. Modale Dettaglio Entità
- Header con gradiente blu sfumato istituzionale, avatar/icona in evidenza con glow circolare, badge pill di stato e pulsante chiusura.
- Contenuto a card raggruppate per tipologia (anagrafica, accessi, campi personalizzati con pill dedicate).

### F. Floating Action Button (Export Excel)
- Pulsante circolare compatto (`FloatingActionButton`, `shape: const CircleBorder()`) con sola icona (`Icons.table_view_rounded`) e tooltip descrittivo.
- Posizionamento: sollevato di 50px dal fondo (`padding: EdgeInsets.only(bottom: 50.0)`).
- Visibilità: DEVE essere nascosto (`floatingActionButton: _isAdvancedFiltersOpen ? null : ...`) quando il drawer filtri avanzati è aperto.


## 6. WORKFLOW GUIDA: GENERAZIONE NUOVA ENTITÀ (TEMPLATE USERS)
Quando viene richiesta l'implementazione di una nuova entità (es. Courses, Modules, Enrollments, Certifications, etc.), seguire SEMPRE la seguente procedura standard in 6 step:

### STEP 1: Modello Dati Isar (`lib/features/<feature>/models/<entity>.dart`)
1. Creare la classe annotata `@collection` con `@Id() int id;` (o id Moodle/API).
2. Tipizzare nativamente tutti i campi (salvare direttamente `DateTime`, `int`, `double`, `bool`; non rimandare il parsing alla UI).
3. Includere factory `fromJson` difensivo con parsing flessibile (Unix timestamp secondi/ms, formati testuali IT/EN, fallback sicuri).
4. Fornire getter di convenienza (es. formattazioni, etichette di stato, helper aggregati).
5. Eseguire: `dart run build_runner build --delete-conflicting-outputs`.

### STEP 2: Registrazione Isar & Protezione Difensiva
1. Aggiungere `<Entity>Schema` in `main.dart` all'apertura del database: `Isar.open([AppSettingsSchema, UserSchema, <Entity>Schema, ...])`.
2. Aggiungere blocco `try-catch` difensivo in `main.dart` subito dopo l'apertura per intercettare disallineamenti di schema durante lo sviluppo:
   ```dart
   try {
     await isar.<entityPlural>.where().findAll();
   } catch (e) {
     debugPrint('[Isar] Disallineamento schema <Entity>: $e. Pulizia tabella.');
     await isar.writeTxn(() async => await isar.<entityPlural>.clear());
   }
   ```
3. Registrare il conteggio e la funzione di reset in `lib/features/database/db_settings_view.dart`.

### STEP 3: Sincronizzazione API (`lib/features/sync/`)
1. Aggiungere `DateTime? last<EntityPlural>SyncDate` in `AppSettings` (con build_runner).
2. Aggiungere scheda/CTA di sincronizzazione in `sync_view.dart` con data ultimo sync.
3. Chiamata API all'endpoint corrispondente con Basic Auth, deserializzazione dell'array elementi e upsert massivo:
   ```dart
   await isar.writeTxn(() async => await isar.<entityPlural>.putAll(items));
   ```

### STEP 4: Servizio Export Excel (`lib/features/<feature>/services/<entity>_excel_exporter.dart`)
1. Creare servizio dedicato basato sul package `excel`.
2. Applicare le convenzioni grafiche istituzionali:
   - Header compatto senza righe vuote superflue, font bold, sfondo scuro o brand.
   - Colonne date con `DateCellValue` e formato data nativo Excel.
   - Colonne numeriche con `IntCellValue` o `DoubleCellValue`.
   - Evidenziazione condizionale delle righe (es. righe sospese o disattivate evidenziate con sfondo colorato).
3. Supporto cross-platform per salvataggio file (Web: download browser via blob; Desktop: salvataggio locale o file picker).

### STEP 5: Schermata Vista Tabellare (`lib/features/<feature>/<entity>_list_view.dart`)
Replicare fedelmente la struttura di `UsersListView`:
1. `_loadItems()` con `try-catch` difensivo su Isar e listener `isar.<entityPlural>.watchLazy()`.
2. Header con titolo grande e sottotitolo.
3. Barra di ricerca con clear integrato che filtra in tempo reale su codice, nome, descrizioni e date.
4. Drawer laterale per filtri avanzati animato (340px ↔ 0px), con selettori a 3 stati per booleani, multi-selezione con modale per liste lunghe e date-range picker.
5. Barra chips dei filtri attivi con rimozione rapida e pulsante "Cancella tutti".
6. Tabella responsive Material 3 senza griglie Excel, con hover, colonna azioni (dettaglio), colonna ID badge, pill di stato colorate e ordinamento colonne.
7. Footer responsive con `LayoutBuilder`, paginazione a 50 elementi e contatore elementi filtrati.
8. Floating Action Button circolare sollevato (+50px) per export Excel, nascosto automaticamente se i filtri avanzati sono aperti.
9. Modale di dettaglio entità a schede/card tematizzate.

### STEP 6: Navigazione e Integrazione UI
1. Aggiungere la rotta fortemente tipizzata in `lib/core/navigation/app_router.dart`.
2. Aggiungere la voce corrispondente nella sidebar principale `lib/core/widgets/app_sidebar.dart`.