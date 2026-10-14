# CyberProTrain Admin

Dashboard gestionale enterprise desktop e web per la formazione e l'amministrazione didattica, sviluppata in Flutter con architettura reattiva Riverpod e database locale Isar.

---

## 🚀 Caratteristiche Principali

### 📊 Dashboard & Analytics Didattica
- **Metriche KPI in Tempo Reale:** Monitoraggio di Utenti Iscritti, Utenti Attivi (utenti con primo accesso effettivo), Partecipanti Didattici e Totale Iscrizioni multi-corso.
- **Ripartizione e Distribuzione:** Grafici interattivi e responsive per Genere (Maschile, Femminile, Non Classificato), Lingua preferita e avanzamento didattico (Completati, In Corso, Solo Iscritti, Sincrono/Asincrono).
- **Gestione Esclusioni Corsi:** Possibilità di escludere ID corso specifici dalle elaborazioni aggregate, grafici e KPI della dashboard.

### 👥 Gestione Entità & Monitoraggio
- **Users:** Anagrafica utenti con filtri avanzati a cassetto laterale, ricerca dinamica e visualizzazione dettagli con campi personalizzati.
- **Courses & Categories:** Catalogo corsi, categorie didattiche e classificazione automatica tipologia corso (`sync` vs `async`).
- **Badges & Course Info:** Tracciamento certificazioni, sezioni didattiche, moduli attività e risorse.
- **Progresso & Statistiche:** Monitoraggio fruizione e tracking attività didattiche (`stat_mdl`).
- **Iscrizioni:** Registro iscrizioni utenti ai corsi (`user_course_enrolled`).
- **Export Excel (.xlsx):** Servizio di esportazione tabellare con formattazione istituzionale, stili personalizzati ed evidenziazioni condizionali.

### ⚙️ Moduli di Sistema & Rete
- **Sincronizzazione Dati (Sync):** Chiamate HTTP concorrenti con autenticazione Basic, recupero paginato/strutturato e upsert massivo su database Isar locale.
- **Rete & Proxy:** Supporto per proxy aziendale HTTP/HTTPS, auto-detect di sistema, file PAC, autenticazione proxy e bypass SSL inspection.
- **Gestione Database Locale:** Monitoraggio conteggio record per tabella Isar e funzioni di reset mirato.

### 🔄 Auto-Update & Rilascio Automatico
- **Controllo Aggiornamenti In-App:** Rilevamento automatico all'avvio e manuale da menu *Impostazioni > Aggiornamenti* tramite GitHub Releases (`gimox/dashbaord_ct`).
- **Download & Installazione:** Download in streaming con progress bar e lancio automatico dell'installer specifico per la piattaforma:
  - **Windows:** Setup eseguibile Inno Setup senza richiesta di privilegi di amministratore (`PrivilegesRequired=lowest`).
  - **macOS:** Immagine disco `.dmg` montabile.
  - **Linux:** Archivio `tar.gz` portabile.

---

## 🛠️ Stack Tecnologico

- **Framework:** [Flutter](https://flutter.dev) (Desktop macOS, Windows, Linux & Web App).
- **State Management:** [Riverpod](https://riverpod.dev) (`flutter_riverpod`, `StateNotifierProvider`).
- **Database Locale:** [Isar Database Community](https://isar.dev) (`isar_community`, `isar_community_flutter_libs`).
- **Navigazione:** [GoRouter](https://pub.dev/packages/go_router).
- **UI / Design System:** Material 3 con palette istituzionale (`AppTheme.primaryBlue`, `AppTheme.accentRed`).
- **Export:** [Excel](https://pub.dev/packages/excel) con tipizzazione nativa di date e numeri.
- **Rete:** `universal_io` per compatibilità multipiattaforma e rispetto dei proxy di sistema.

---

## 📦 Installazione e Avvio Locale

### Prerequisiti
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (canale `stable`, Dart >= 3.2.0)
- Xcode (per macOS) / Visual Studio C++ (per Windows) / Toolchain C++ & GTK3 (per Linux)

### Configurazione
1. Clona il repository:
   ```bash
   git clone https://github.com/gimox/dashbaord_ct.git
   cd dashbaord_ct
   ```

2. Installa le dipendenze:
   ```bash
   flutter pub get
   ```

3. Genera il codice Isar e Riverpod (se necessario):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Avvia l'applicazione in modalità debug/sviluppo:
   ```bash
   # Desktop macOS
   flutter run -d macos

   # Desktop Windows
   flutter run -d windows

   # Desktop Linux
   flutter run -d linux

   # Web
   flutter run -d chrome
   ```

---

## 🚀 Script di Build & Release

Nella root del progetto è presente lo script interattivo [`build_release.sh`](./build_release.sh) per automatizzare l'intero ciclo di release.

Lancia semplicemente:
```bash
./build_release.sh
```

Lo script consente di:
1. Scegliere l'incremento di versione tra **Minor** (`1.1.0`), **Major** (`2.0.0`) o **Patch** (`1.0.1`).
2. Aggiornare automaticamente `pubspec.yaml` con la nuova versione e build number.
3. Creare il commit di release e sincronizzare il branch con GitHub.
4. Generare e inviare il tag annotato (`vX.Y.Z`) su GitHub.
5. Innescare la GitHub Action `.github/workflows/desktop_release.yml` che compila e pubblica automaticamente gli asset su GitHub Releases.

---

## 🤖 CI/CD - GitHub Actions

La pipeline definita in [`.github/workflows/desktop_release.yml`](./.github/workflows/desktop_release.yml) si attiva automaticamente alla pubblicazione di un tag `v*` e produce:
- **`App_macOS.dmg`**: Immagine disco DMG montabile per macOS.
- **`App_Windows_Setup.exe`**: Installer Inno Setup per Windows (installazione no-admin in LocalAppData).
- **`App_Windows.zip`**: Pacchetto compresso portabile per Windows.
- **`App_Linux.tar.gz`**: Archivio per sistemi Linux x86_64.
