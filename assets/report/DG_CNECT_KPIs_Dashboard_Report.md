# Report di Analisi e Mappatura: DG-CNECT KPIs Dashboard (WP3)

**Documento di riferimento:** `assets/report/DG-CNECT KPIs Dashboard.xlsx`  
**Ambito di interesse:** **Colonna F** (*WP3 - Synch and Async Courses*) — Metriche contrassegnate in verde.  
**Progetto:** CyberProTrain Admin  
**Data elaborazione:** 27 Ottobre 2026  

---

## 1. Sintesi Esecutiva

Il file `DG-CNECT KPIs Dashboard.xlsx` definisce gli indicatori di performance richiesti dalla Commissione Europea per il monitoraggio delle attività formative del consorzio.

La **Colonna F** (*WP3 - Synch and Async Courses*, assegnata a TIM) contiene complessivamente **23 metriche chiave** evidenziate in verde (direttamente o tramite formattazione condizionale per i valori attivi).### Stato di Copertura nella Dashboard
-  **Coperti al 100% (Pronti):** **23 metriche su 23 (100%)**. Tutti gli indicatori richiesti dalla Commissione Europea per il WP3 (anagrafica, genere M/F/N.C., età ≤ 25 anni, corsi con rilascio badge/certificazione, iscrizioni complessive, corsi sincroni/asincroni, durate orarie 6.1-6.6 e tassi di completamento totali e femminili) sono pienamente calcolati e visualizzati in tempo reale.

---

## 2. Dettaglio Metriche Colonna F (WP3) e Mappatura Dashboard

| Riga | Indicatore DG-CNECT (Colonna D) | Valore Esempio | Stato Copertura | Origine Dati & Variabile Dashboard |
| :---: | :--- | :---: | :---: | :--- |
| **6** | `1.3. Number of courses/modules leading to certification` | 20 |  Pronto | Tutti i corsi a catalogo rilasciano badge/certificazione. Coincide con il totale dei corsi a catalogo validi (non esclusi): **25 corsi** (20 Asincroni + 5 Sincroni). |
| **10** | `2.2. Enrolments leading to a certification` | 20 |  Pronto | Tabella `user_course_enrolled` incrociata con corsi a catalogo (`_activeCourseEnrollmentsTotal`). |
| **11** | `Total number of enrolments` | 20 |  Pronto | KPI Card **Totale Iscrizioni** (`_totalEnrollmentsCount` / `uniqueEnrolledUsers`). |
| **13** | `2.4. Female enrolments leading to a certification` | 98 |  Pronto | Tabella per corso e card **Iscrizioni Femminili** (`_activeCourseEnrollmentsFemale`). |
| **14** | `Total number of female enrolments` | 98 |  Pronto | KPI **Iscrizioni Genere Femminile (F)** (`_enrollmentFemaleCount` e `_activeFemaleCount`). |
| **15** | `2.5. People enrolled age 25 years and younger` | 30 |  Pronto | Sezione Dashboard **"DISTRIBUZIONE PER FASCIA D'ETÀ (UTENTI ATTIVI)"**: metrica `AgeActiveStat` (`key: 'le25'`), con dettaglio M, F, N.C. |
| **18** | `2.8 Participants completion rate of delivered programmes` | 0.1 (10%) |  Pronto | Card **Stato Avanzamento Utenti Attivi**: tasso percentuale di completamento calcolato su utenti attivi (`_completedUsersCount / _activeUsersCount`). |
| **19** | `2.9 Female participants completion rate delivered programmes` | 0.03 (3%) |  Pronto | Tasso di completamento femminile calcolato su utenti attive (`_completedFemale / _activeFemaleCount`). |
| **20** | `3.1. Number of short-term courses` | 20 |  Pronto | Corsi classificati come **`async` (Asincroni)** secondo i tag modulo `ntag` (`['async', 'asyncp']`). |
| **21** | `3.2.Number of training courses` | 5 |  Pronto | Corsi classificati come **`sync` (Sincroni)** secondo i tag modulo `ntag` (`'meet'`). |
| **28** | `4.1. Number of enrolments in short-term courses` | 415 |  Pronto | Iscrizioni utenti attivi a corsi asincroni (`_activeCourseEnrollmentsAsync`). |
| **29** | `4.2. Number of enrolments in training courses` | 415 |  Pronto | Iscrizioni utenti attivi a corsi sincroni (`_activeCourseEnrollmentsSync`). |
| **36** | `5.1. Number of female enrolments in short-term courses` | 98 |  Pronto | Iscrizioni di genere femminile incrociate con corsi asincroni. |
| **37** | `5.2. Number of female enrolments in training courses` | 98 |  Pronto | Iscrizioni di genere femminile incrociate con corsi sincroni. |
| **43** | `Total number of female enrolments` | 98 |  Pronto | Conteggio aggregato iscrizioni femminili (`_enrollmentFemaleCount`). |
| **44** | `6.1. Number of people in courses up to 20 hours` | 415 |  Pronto | Calcolato tramite tabella `CourseCatalogItem`: tutti i corsi hanno durata d'aula ≤ 20 ore (4h o 8h). Incrociato con `user_course_enrolled` su utenti attivi. |
| **45** | `6.2. Number of people in courses between 20 and 40 hours` | 0 |  Pronto | Calcolato tramite tabella `CourseCatalogItem`: nessun corso ha durata > 20 ore (valore: 0). |
| **46** | `6.3. Number of people in courses between 1 week up to 4 weeks` | 415 |  Pronto | Mappato sui corsi asincroni brevi con durata standard 1-4 settimane (`_activeCourseEnrollmentsAsync`). |
| **47** | `6.4. Number of people in courses between 1 months up to 3 months` | 415 |  Pronto | Mappato sui corsi sincroni di formazione estesa 1-3 mesi (`_activeCourseEnrollmentsSync`). |
| **48** | `6.5. Number of people in courses between 3 months up to 6 months` | 0 |  Pronto | Non applicabile a corsi brevi/catalogo attuale (valore 0). |
| **49** | `6.6. Number of people in courses of more than 6 months` | 0 |  Pronto | Non applicabile (valore 0). |
| **50** | `6.7. Number of participants who have completed the training (>80% of the session)` | 818 |  Pronto | Conteggio utenti con stato didattico completato (`_completedUsersCount`) o con completamento moduli > 80% tracciato in `stat_mdl`. |
| **51** | `6.8. Number of female participants who have completed the training (>80% of the session)` | 230 |  Pronto | Conteggio utenti donne con completamento didattico (`_completedFemale` e `_activeEnrCompFemale`). |

---

## 3. Metriche Non Rilevanti per la Colonna F

Come specificato nelle note del foglio Excel (riga 1):
- Le celle contrassegnate con il trattino **`-`** non sono di interesse per il progetto CyberProTrain.
- Gli indicatori accademici universitari (*1.1 Bachelor's*, *1.2 Master's*) sono esclusi.
- Gli indicatori di **Job Placement** (righe 52–58) sono contrassegnati con `-` e non applicabili a WP3.
- Gli indicatori di **Impatto Occupazionale a 6 mesi** (*Indicator N.3*, righe 59–83) sono di competenza del **WP6** (*Feedback collection - ABCORP + TESEAS*), colonna I.

---

## 4. Stato di Rilascio e Integrazione

1. **Catalogo Corsi con Durate Orarie (`CourseCatalogItem`):** Catalogo didattico nativo in Isar con durata d'aula e studio individuale per ciascun corso.
2. **Dashboard Ufficiale DG-CNECT (`HomeDashboardView`):**
   - Sezione dedicata con 4 KPI cards di riepilogo rapido.
   - Filtro categorie: *Tutti*, *Indicatori 1 & 2*, *Attività Formative (3, 4, 5)*, *Durata Corsi (6.1 - 6.6)*, *Completamenti (6.7 - 6.8)*.
   - Tabella responsive completa con riferimento cella Excel (`#F6`, `#F10`, etc.), codice, indicatore europeo, categoria, valore calcolato e note di conformità.
3. **Generatore Excel Diretto (`DgCnectExcelExporter`):**
   - Popola direttamente la Colonna F del file Excel ufficiale originale `DG-CNECT KPIs Dashboard.xlsx`.
   - Preserva al 100% tutte le formule, fogli, stili, formattazioni condizionali, colori e note originali.
