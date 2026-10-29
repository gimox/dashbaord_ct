import 'package:isar_community/isar.dart';
import '../models/course_catalog_item.dart';
import '../../sync/models/course.dart';

/// Dati predefiniti del catalogo corsi (34 corsi ufficiali con durate orarie).
/// Vengono caricati direttamente in memoria/database all'avvio se la tabella è vuota,
/// senza richiedere la lettura o il parsing a runtime del file Excel.
class DefaultCourseCatalog {
  static final List<CourseCatalogItem> initialItems = [
    CourseCatalogItem()
      ..courseCode = "1.1"
      ..learningPath = "CYBERSECURITY BASIC Module I Fundamentals of IT Security"
      ..title = "1) Introduction to the fundamental concepts of computer security: In this course, we will provide an overview of the fundamental principles of computer security. Students will learn about threats, vulnerabilities, and the basic defense strategies that can be adopted to protect systems and data."
      ..titleIt = "1) Introduzione ai concetti principali della sicurezza informatica: In questo corso, forniremo una panoramica dei principi fondamentali della sicurezza informatica. Gli studenti apprenderanno le minacce, le vulnerabilità e le strategie di difesa di base che possono essere adottate per proteggere i sistemi e i dati."
      ..durationHours = 8.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.2"
      ..learningPath = "CYBERSECURITY BASIC Module I Fundamentals of IT Security"
      ..title = "2) Principles of risk reduction: The course focuses on the strategies and methodologies used to identify, assess and mitigate risks in cybersecurity, in order to protect digital assets and reduce vulnerabilities. What is cyberspace and how is it evolving: not only social media, e-mail and the World Wide Web, but increasingly warfare, IoT, critical infrastructures and artificial intelligence"
      ..titleIt = "2) Principi di riduzione del rischio: il corso si concentra sulle strategie e le metodologie utilizzate per identificare, valutare e mitigare i rischi nella sicurezza informatica, al fine di proteggere gli asset digitali e ridurre le vulnerabilità. Cos'è il cyberspazio e come si sta evolvendo: non solo social media, e-mail e World Wide Web, ma sempre più guerra, IoT, infrastrutture critiche e intelligenza artificiale"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.3"
      ..learningPath = "CYBERSECURITY BASIC Module I Fundamentals of IT Security"
      ..title = "3) Data protection: This course provides an in-depth exploration of the principles, technologies, and best practices for protecting sensitive data throughout its lifecycle. Students will develop both theoretical knowledge and practical skills related to the protection of data integrity, confidentiality, and availability in compliance with international standards such as ISO/IEC 27001."
      ..titleIt = "3) Protezione dei dati: questo corso fornisce un'esplorazione approfondita dei principi, delle tecnologie e delle best practice per la protezione dei dati sensibili durante tutto il loro ciclo di vita. Gli studenti svilupperanno sia conoscenze teoriche che competenze pratiche relative alla protezione dell'integrità, della riservatezza e della disponibilità dei dati in conformità con gli standard internazionali come ISO/IEC 27001."
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.4"
      ..learningPath = "CYBERSECURITY BASIC Module I Fundamentals of IT Security"
      ..title = "4) Device security: In this course, we will provide an overview of the main security devices used to protect networks and IT systems from both external and internal threats."
      ..titleIt = "4) Sicurezza dei dispositivi: in questo corso forniremo una panoramica dei principali dispositivi di sicurezza utilizzati per proteggere le reti e i sistemi IT da minacce esterne e interne."
      ..durationHours = 8.0
      ..individualStudyHours = 0.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.5"
      ..learningPath = "CYBERSECURITY BASIC Module I Fundamentals of IT Security"
      ..title = "5) Network security: In this module, we will explore the fundamentals of protecting networks from both internal and external threats. Students will learn both the theory and practical skills necessary to implement and manage effective security solutions."
      ..titleIt = "5) Sicurezza di rete: in questo modulo esploreremo i principi della protezione delle reti da minacce interne ed esterne. Gli studenti apprenderanno sia la teoria che le competenze pratiche necessarie per implementare e gestire soluzioni di sicurezza efficaci."
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "2.1"
      ..learningPath = "CYBERSECURITY BASIC Module II: Fundamentals of Operating Systems and Databases"
      ..title = "1) Basic Operating Systems Concepts: The course provides an overview of the fundamental concepts of operating systems, including concepts such as processes, memory, file management, and user interfaces;"
      ..titleIt = "1) Concetti di base dei Sistemi Operativi: il corso fornisce una panoramica dei concetti fondamentali dei sistemi operativi, inclusi concetti quali processi, memoria, gestione dei file e interfacce utente;"
      ..durationHours = 4.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "2.2"
      ..learningPath = "CYBERSECURITY BASIC Module II: Fundamentals of Operating Systems and Databases"
      ..title = "2) Introduction to Databases: The course introduces the basic concepts of databases, including database types, data models, queries and data management;"
      ..titleIt = "2) Introduzione ai Database: il corso introduce i concetti base dei database, inclusi i tipi di database, i modelli di dati, le query e la gestione dei dati;"
      ..durationHours = 8.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "2.3"
      ..learningPath = "CYBERSECURITY BASIC Module II: Fundamentals of Operating Systems and Databases"
      ..title = "3) Operating system security: The course explores the main threats to operating system security and countermeasures to protect systems from cyber attacks, malware and other vulnerabilities;"
      ..titleIt = "3) Sicurezza del Sistema Operativo: il corso esplora le principali minacce alla sicurezza del sistema operativo e le contromisure per proteggere i sistemi da attacchi informatici, malware e altre vulnerabilità;"
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "2.4"
      ..learningPath = "CYBERSECURITY BASIC Module II: Fundamentals of Operating Systems and Databases"
      ..title = "4) Data Backup and Recovery: The course covers practices and procedures for safely backing up data, ensuring its availability in the event of loss or corruption, and how to restore data in a timely and efficient manner should the need arise."
      ..titleIt = "4) Backup e ripristino dei dati: il corso prevede le pratiche e le procedure per eseguire il backup sicuro dei dati, assicurandone la disponibilità in caso di perdita o danneggiamento e come ripristinare i dati in modo tempestivo ed efficiente qualora si presenti la necessità."
      ..durationHours = 4.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.1"
      ..learningPath = "CYBERSECURITY BASIC Module III: Networking aspects and TCP/IP protocols"
      ..title = "1) Network Security Fundamentals: The course provides an overview of the fundamental concepts of network security, including communication security principles, data protection in transit and network access management, providing a solid foundation for understanding and implementing basic security measures in networks; 2) TCP/IP Protocols: This course examines in detail the TCP/IP protocols, including Transmission Control Protocol (TCP) and Internet Protocol (IP), along with their roles in network communication, associated vulnerabilities, and best practices to ensure data security; role of firewalls and virtual private networks (VPNs) in protecting networks, examining the operating principles of firewalls, typical VPN configurations and recommended implementations to ensure communications security of the network;"
      ..titleIt = "1) Fondamenti della Sicurezza di Rete: il corso fornisce una panoramica dei concetti base della sicurezza di rete, inclusi i principi di sicurezza delle comunicazioni, la protezione dei dati in transito e la gestione dell'accesso alla rete, fornendo una solida base per comprendere e implementare misure di sicurezza di base nelle reti; 2) Protocolli TCP/IP: questo corso esamina in dettaglio i protocolli TCP/IP, tra cui Transmission Control Protocol (TCP) e Internet Protocol (IP), insieme ai loro ruoli nella comunicazione di rete, alle vulnerabilità associate e alle best practices da seguire per garantire la sicurezza dei dati; ruolo dei firewall e delle reti private virtuali (VPN) nella protezione delle reti, esaminando i principi operativi dei firewall, le configurazioni VPN tipiche e le implementazioni consigliate per garantire la sicurezza delle comunicazioni della rete;"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.2"
      ..learningPath = "CYBERSECURITY BASIC Module III: Networking aspects and TCP/IP protocols"
      ..title = "2) Firewalls and VPNs"
      ..titleIt = "2) Firewalls and VPNs"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.3"
      ..learningPath = "CYBERSECURITY BASIC Module III: Networking aspects and TCP/IP protocols"
      ..title = "3) Intrusion Detection: This course explores the techniques and tools used for network intrusion detection, including attack signatures, behavioral analysis, event correlation, and integration with security management systems. security information (SIEM), in order to identify and respond to threats in real time"
      ..titleIt = "3) Rilevamento delle intrusioni: questo corso esplora le tecniche e gli strumenti utilizzati per il rilevamento delle intrusioni di rete, tra cui tentativi di attacco, analisi comportamentale, correlazione degli eventi e integrazione con i sistemi di gestione della sicurezza. informazioni sulla sicurezza (SIEM), al fine di identificare e rispondere alle minacce in tempo reale"
      ..durationHours = 8.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.4"
      ..learningPath = "CYBERSECURITY BASIC Module III: Networking aspects and TCP/IP protocols"
      ..title = "4) Wireless Security: The course covers best practices and techniques for ensuring the security of wireless networks, including authentication protocols, data encryption, key management, and protection measures against attacks such as data interception and access not authorized to the network."
      ..titleIt = "4) Sicurezza Wireless: il corso riguarda le  best practices e tecniche per garantire la sicurezza delle reti wireless, inclusi i protocolli di autenticazione, crittografia dei dati, gestione delle chiavi e misure di protezione contro attacchi quali l'intercettazione dei dati e l'accesso non autorizzato alla rete."
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "4.1"
      ..learningPath = "Module IV: Introduction to Regulations and Best Practices"
      ..title = "1) Privacy Regulations: Overview of key privacy regulations, such as the GDPR and other national and international laws, and analyzes the implications for organizations, including data protection requirements and sanctions in case of violation;"
      ..titleIt = "1) Normative sulla Privacy: panoramica delle principali normative sulla privacy, come il GDPR e altre leggi nazionali e internazionali, e analisi delle implicazioni per le organizzazioni, inclusi i requisiti di protezione dei dati e le sanzioni in caso di violazione;"
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "4.2"
      ..learningPath = "Module IV: Introduction to Regulations and Best Practices"
      ..title = "2) Data Protection Best Practices: This course reviews best practices and guidelines for protecting sensitive data, including encryption methods, key management, authorized access, and activity monitoring, to ensure security and compliance with privacy regulations;"
      ..titleIt = "2) Best Practices per la protezione dei dati: questo corso esamina le migliori pratiche e le linee guida per la protezione dei dati sensibili, inclusi i metodi di crittografia, la gestione delle chiavi, l'accesso autorizzato e il monitoraggio delle attività, per garantire la sicurezza e la conformità alle normative sulla privacy;"
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "4.3"
      ..learningPath = "Module IV: Introduction to Regulations and Best Practices"
      ..title = "3) Regulatory Compliance: This course addresses organizations' responsibilities to comply with safety regulations and standards, such as ISO 27001 and other industry standards, and provides guidance on how to implement policies, procedures and controls to ensure regulatory compliance"
      ..titleIt = "3) Conformità alla normativa: questo corso affronta le responsabilità delle organizzazioni nel rispettare le normative e gli standard di sicurezza, come ISO 27001 e altri standard di settore, e fornisce indicazioni su come implementare politiche, procedure e controlli per garantire la conformità normativa"
      ..durationHours = 8.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "4.4"
      ..learningPath = "Module IV: Introduction to Regulations and Best Practices"
      ..title = "4) Risk Management: This course examines the methodologies and techniques for identifying, assessing and managing risks related to cybersecurity, including risk analysis, impact assessment and countermeasure planning, in order to reduce the impact of potential threats;"
      ..titleIt = "4) Risk Management \"Gestione del rischio\": questo corso esamina le metodologie e le tecniche per identificare, valutare e gestire i rischi legati alla sicurezza informatica, tra cui l'analisi del rischio, la valutazione dell'impatto e la pianificazione delle contromisure, al fine di ridurre l'impatto delle potenziali minacce"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.1 ADV"
      ..learningPath = "Module I: Fundamentals of Computer Security - Advanced"
      ..title = "1) Insights into Cyber Security: This course delves into advanced topics in cybersecurity, such as ethical hacking techniques, digital forensics, vulnerability management and attack mitigation strategies, offering a detailed view of advanced security challenges and solutions - Advanced Operating System Security: This course explores advanced techniques and strategies to protect operating systems from threats such as malware, security exploits, and zero-day attacks by implementing advanced countermeasures and optimization of security configurations;"
      ..titleIt = "1) Approfondimenti sulla sicurezza informatica: questo corso approfondisce argomenti di livello advanced sulla sicurezza informatica, come tecniche di hacking etico, informatica forense, gestione delle vulnerabilità e strategie di mitigazione degli attacchi, offrendo una visione dettagliata delle sfide e delle soluzioni di sicurezza di livello advanced  - Sicurezza del sistema operativo - livello advanced: questo corso esplora tecniche e strategie avanzate per proteggere i sistemi operativi da minacce quali malware, \"security exploits\" e attacchi di tipo zero-day implementando contromisure avanzate e ottimizzando le configurazioni di sicurezza;"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.2 ADV"
      ..learningPath = "Module I: Fundamentals of Computer Security - Advanced"
      ..title = "2) Advanced Cryptography: This course delves into advanced principles and applications of cryptography, including advanced cryptographic algorithms, security protocols for encrypted communication and key management techniques, providing an in-depth understanding of protecting sensitive data"
      ..titleIt = "2) Crittografia - livello advanced: questo corso approfondisce i principi avanzati e le applicazioni della crittografia, inclusi algoritmi crittografici avanzati, protocolli di sicurezza per comunicazioni crittografate e tecniche di gestione delle chiavi, fornendo una comprensione approfondita della protezione dei dati sensibili"
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "1.3 ADV"
      ..learningPath = "Module I: Fundamentals of Computer Security - Advanced"
      ..title = "3) Security Incident Management: This course examines methodologies and best practices for managing cybersecurity incidents, including preparing for, responding to, and recovering from security events by implementing incident response plans. and post-mortem analysis of the events  -  Threat Analysis: This course covers advanced cyber threat analysis, including profiling attackers, identifying tactics, techniques and procedures (TTPs) used in cyber-attacks, and applying proactive strategies to prevent and counter emerging threats.In cyberspace, maintaining a high level of situation awareness (CDSA) is critical for supporting the decision making process. This can only be trained by simulating real incidents as realistically as possible. A Cyber Range is therefore an essential tool. It allows to simulate complex networks and makes it possible to involve large numbers of participants."
      ..titleIt = "3) Gestione degli incidenti di sicurezza: questo corso esamina le metodologie e le best practices per la gestione degli incidenti di sicurezza informatica, tra cui la preparazione, la risposta e il ripristino da eventi di sicurezza mediante l'implementazione di piani di risposta agli incidenti e l'analisi post-mortem degli eventi -  Analisi delle minacce: questo corso copre l'analisi avanzata delle minacce informatiche, tra cui la profilazione degli aggressori, l'identificazione di tattiche, tecniche e procedure (TTP) utilizzate negli attacchi informatici e l'applicazione di strategie proattive per prevenire e contrastare le minacce emergenti. Nel cyberspazio, mantenere un elevato livello di consapevolezza della situazione (CDSA) è fondamentale per supportare il processo decisionale. Questo può essere allenato solo simulando incidenti reali nel modo più realistico possibile. Un Cyber ​​Range è quindi uno strumento essenziale. Consente di simulare reti complesse e rende possibile coinvolgere un gran numero di partecipanti."
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "2.1 ADV"
      ..learningPath = "Module II: Advanced Management of Operating Systems and DBs"
      ..title = "1) Advanced Operating Systems Management: This course delves into advanced techniques for managing operating systems, including automating administration tasks, optimizing system performance, and advanced configuration of services and processes;  Database Optimization: This course examines best practices and strategies for optimizing database performance, including query optimization, data indexing, memory management, and system parameter configuration;"
      ..titleIt = "1) Gestione dei sistemi operativi - livello advanced: questo corso approfondisce le tecniche avanzate per la gestione dei sistemi operativi, tra cui l'automazione delle attività di amministrazione, l'ottimizzazione delle prestazioni del sistema e la configurazione avanzata di servizi e processi;  Ottimizzazione del database: questo corso esamina le best practices e le strategie per ottimizzare le prestazioni del database, tra cui l'ottimizzazione delle query, l'indicizzazione dei dati, la gestione della memoria e la configurazione dei parametri di sistema;"
      ..durationHours = 8.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "2.2 ADV"
      ..learningPath = "Module II: Advanced Management of Operating Systems and DBs"
      ..title = "2) Advanced Database Security: This course delves into advanced techniques to protect databases from internal and external threats, including data encryption, access control, vulnerability management, and advanced security event logging  Advanced Network Services Management: This course examines advanced methodologies and strategies for managing network services, including configuring services, managing network protocols, and implementing security policies to ensure the availability and reliability of network services; Advanced Monitoring: This course covers advanced techniques for monitoring systems and networks, including implementing real-time monitoring solutions, analyzing monitoring data for performance optimization and troubleshooting , and advanced reporting on system health and security."
      ..titleIt = "2) Sicurezza del Data Base - livello advanced: questo corso approfondisce le tecniche avanzate per proteggere i database da minacce interne ed esterne, tra cui crittografia dei dati, controllo degli accessi, gestione delle vulnerabilità e registrazione avanzata degli eventi di sicurezza - Gestione dei Servizi di Rete - livello advanced: questo corso esamina metodologie e strategie avanzate per la gestione dei servizi di rete, tra cui la configurazione dei servizi, la gestione dei protocolli di rete e l'implementazione di policy di sicurezza per garantire la disponibilità e l'affidabilità dei servizi di rete;  Monitoraggio -questo corso prevede tecniche avanzate per il monitoraggio di sistemi e reti, tra cui l'implementazione di soluzioni di monitoraggio in tempo reale, l'analisi dei dati di monitoraggio per l'ottimizzazione delle prestazioni e la risoluzione dei problemi, nonché la creazione di report avanzati sullo stato di salute e sulla sicurezza del sistema"
      ..durationHours = 8.0
      ..individualStudyHours = 4.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.1 ADV"
      ..learningPath = "Module III: Advanced Architectural Security"
      ..title = "1) Advanced Web Architectures: This course delves into advanced architectures for developing complex web applications, including microservices architecture, serverless architectures, and scaling techniques to handle high workloads; Advanced Web Application Security: This course examines advanced techniques and best practices for protecting web applications from threats such as SQL injection attacks, cross-site scripting (XSS), and session theft by implementing advanced countermeasures and vulnerability management;"
      ..titleIt = "1) Architettura Web - livello advanced: questo corso approfondisce le architetture avanzate per lo sviluppo di applicazioni Web complesse, tra cui l'architettura dei microservizi, le architetture serverless e le tecniche di scalabilità per gestire carichi di lavoro elevati; Sicurezza delle applicazioni Web - livello advanced: questo corso esamina tecniche avanzate e best practice per proteggere le applicazioni Web da minacce quali attacchi di iniezione SQL, cross-site scripting (XSS) e furto di sessione implementando contromisure avanzate e gestione delle vulnerabilità;"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.2 ADV"
      ..learningPath = "Module III: Advanced Architectural Security"
      ..title = "2) Advanced Mobile Architectures: This course delves into advanced architectures for mobile application development, including cross-platform frameworks, performance optimization, and the integration of advanced features such as augmented reality and geolocation"
      ..titleIt = "2) Architetture Rete Mobili - livello advanced: questo corso approfondisce le architetture avanzate per lo sviluppo di applicazioni mobili, inclusi framework multipiattaforma, ottimizzazione delle prestazioni e integrazione di funzionalità avanzate quali realtà aumentata e geolocalizzazione"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.3 ADV"
      ..learningPath = "Module III: Advanced Architectural Security"
      ..title = "3) Advanced mobile application security: This course examines advanced techniques and strategies to protect mobile applications from threats such as reverse engineering, data interception and platform security vulnerabilities, through the implementation of advanced countermeasures and threat analysis"
      ..titleIt = "3) Sicurezza delle Applicazioni Mobili - livello advanced: questo corso esamina tecniche e strategie avanzate per proteggere le applicazioni mobili da minacce quali reverse engineering, intercettazione dei dati e vulnerabilità della sicurezza della piattaforma, attraverso l'implementazione di contromisure avanzate e analisi delle minacce."
      ..durationHours = 8.0
      ..individualStudyHours = 0.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "3.4 ADV"
      ..learningPath = "Module III: Advanced Architectural Security"
      ..title = "4) Advanced Security Testing: This course covers advanced methodologies and tools for conducting application security testing, including advanced penetration testing, static and dynamic code analysis, and API security assessment, to identify and remediate vulnerabilities before release."
      ..titleIt = "4) Test di sicurezza - livello advanced: questo corso copre metodologie e strumenti avanzati per condurre test di sicurezza delle applicazioni, tra cui test di penetrazione avanzati, analisi del codice statico e dinamico e valutazione della sicurezza delle API, per identificare e correggere le vulnerabilità prima del rilascio"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "4.1 ADV"
      ..learningPath = "Module IV: Advanced Network Security"
      ..title = "1) Advanced Network Intrusion Detection and Prevention: This course delves into advanced techniques for detecting and preventing network intrusions, including the use of machine learning algorithms, anomaly detection, and behaviour analysis."
      ..titleIt = "1) Rilevamento e prevenzione delle intrusioni di Rete - livello advanced: questo corso approfondisce le tecniche avanzate per rilevare e prevenire le intrusioni di rete, tra cui l'uso di algoritmi di apprendimento automatico, rilevamento delle anomalie e analisi del comportamento"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "4.2 ADV"
      ..learningPath = "Module IV: Advanced Network Security"
      ..title = "2) Advanced Wireless Network Security: This course examines advanced techniques for securing wireless networks, including encryption protocols, secure access controls, and measures to prevent and mitigate attacks such as man-in-the-middle and rogue access points"
      ..titleIt = "2) Sicurezza delle Reti Wireless - livello advanced: questo corso esamina le tecniche avanzate per proteggere le reti wireless, tra cui protocolli di crittografia, controlli di accesso sicuri e misure per prevenire e mitigare attacchi come man-in-the-middle e punti di accesso non autorizzati"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "5.1 ADV"
      ..learningPath = "Module V: Advanced Cloud Security- TECH"
      ..title = "1) Advanced Cloud Infrastructure Security: This course delves into advanced strategies for securing cloud infrastructures, including identity and access management, secure configuration, and monitoring of cloud resources."
      ..titleIt = "1) Sicurezza delle infrastrutture Cloud - livello advanced: questo corso approfondisce le strategie avanzate per la protezione delle infrastrutture cloud, tra cui la gestione dell'identità e dell'accesso, la configurazione sicura e il monitoraggio delle risorse cloud."
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "5.2 ADV"
      ..learningPath = "Module V: Advanced Cloud Security- TECH"
      ..title = "2) Advanced Cloud Application Security: This course covers advanced techniques for securing applications deployed in the cloud, including secure development practices, threat modeling, and the use of cloud-native security services. ) Advanced Data Security in the Cloud: This course examines advanced methods for protecting data in cloud environments, including encryption, tokenization, and secure data storage and transmission."
      ..titleIt = "2) Sicurezza delle applicazioni Cloud - livello advanced: questo corso prevede tecniche avanzate per la protezione delle applicazioni distribuite nel cloud, tra cui pratiche di sviluppo sicuro, modellazione delle minacce e utilizzo di servizi di sicurezza nativi del cloud. Sicurezza dei dati nel Cloud - livello advanced: questo corso esamina metodi avanzati per la protezione dei dati negli ambienti cloud, tra cui crittografia, gestione dei token e archiviazione e trasmissione sicure dei dati"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "5.3 ADV"
      ..learningPath = "Module V: Advanced Cloud Security- TECH"
      ..title = "3) Advanced Container Security: This course covers advanced techniques for securing containerized applications and environments, including container orchestration security, runtime protection, and vulnerability management"
      ..titleIt = "3) Sicurezza dei \"Container\" - livello advanced: questo corso copre tecniche avanzate per proteggere applicazioni e ambienti containerizzati, tra cui la sicurezza dell'orchestrazione dei container, la protezione del runtime e la gestione delle vulnerabilità"
      ..durationHours = 8.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "6.1 ADV"
      ..learningPath = "Module VI: Artificial Intelligence in Cybersecurity -TECH"
      ..title = "1) Introduction to AI in Cybersecurity: This course provides an overview of how AI and machine learning are applied in cybersecurity, including the basics of machine learning algorithms and their applications in threat analysis."
      ..titleIt = "1) Introduzione all'AI nella Cybersecurity: questo corso fornisce una panoramica di come l'intelligenza artificiale e l'apprendimento automatico vengono applicati alla sicurezza informatica, comprese le basi degli algoritmi di machine learning e le loro applicazioni nell'analisi delle minacce."
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "6.2 ADV"
      ..learningPath = "Module VI: Artificial Intelligence in Cybersecurity -TECH"
      ..title = "AI-Driven Threat Detection: This course explores an AI application in civilian and military cybersecurity, focusing on Machine Learning for threat intelligence through case studies and hands-on ML model implementation."
      ..titleIt = "2) Rilevamento delle minacce tramite AI: questo corso esplora un'applicazione dell'intelligenza artificiale nella sicurezza informatica civile e militare, concentrandosi sulla Machine Learning per la threat intelligence attraverso casi di studio e l'implementazione pratica di modelli di apprendimento automatico."
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
    CourseCatalogItem()
      ..courseCode = "6.3 ADV"
      ..learningPath = "Module VI: Artificial Intelligence in Cybersecurity -TECH"
      ..title = "3) Machine Learning for Incident Response: This course covers how machine learning models can be used to automate and enhance incident response processes, including the analysis of security logs, automated threat hunting, and the development of self-learning security systems  Machine Learning for SIEM Solutions: This course explores the integration of machine learning techniques into Security Information and Event Management (SIEM) solutions. The program covers key topics such as security data analysis, event correlation, and security automation. Through theoretical and practical lessons, participants will gain skills to implement and manage effective and innovative SIEM solutions."
      ..titleIt = "3)  Machine Learning per la \"Incident Response\": questo corso illustra come i modelli di apprendimento automatico possono essere utilizzati per automatizzare e migliorare i processi di risposta agli incidenti, tra cui l'analisi dei registri di sicurezza, la ricerca automatizzata delle minacce e lo sviluppo di sistemi di sicurezza autoapprendenti. Machine Learning per soluzioni SIEM: questo corso esplora l'integrazione di tecniche di machine learning nelle soluzioni di Security Information and Event Management (SIEM). Il programma prevede argomenti chiave come l'analisi dei dati di sicurezza, la correlazione degli eventi e l'automazione della sicurezza. Attraverso lezioni teoriche e pratiche, i partecipanti acquisiranno competenze per implementare e gestire soluzioni SIEM efficaci e innovative."
      ..durationHours = 4.0
      ..individualStudyHours = 2.0
      ..courseType = "async"
      ..updatedAt = DateTime(2026, 1, 1),
  ];

  /// Popola i dati di default nel database Isar se la tabella è vuota.
  /// Se sono presenti corsi in anagrafica locale (Moodle), correla automaticamente i relativi `courseId`.
  static Future<int> seedIfEmpty(Isar isar) async {
    final count = await isar.courseCatalogItems.count();
    if (count > 0) return 0;

    final courses = await isar.courses.where().findAll();
    final items = initialItems.map((template) {
      final item = CourseCatalogItem()
        ..courseCode = template.courseCode
        ..learningPath = template.learningPath
        ..title = template.title
        ..titleIt = template.titleIt
        ..durationHours = template.durationHours
        ..individualStudyHours = template.individualStudyHours
        ..courseType = template.courseType
        ..updatedAt = template.updatedAt;

      // Incrocio automatico con corsi Moodle se presenti
      if (courses.isNotEmpty) {
        final codeVal = template.courseCode ?? '';
        for (final c in courses) {
          final imgc = c.customfields?.firstWhere(
            (cf) => cf.shortname?.toLowerCase() == 'imgc',
            orElse: () => CourseCustomField(),
          ).value?.trim();

          if (imgc != null && imgc.isNotEmpty) {
            if (codeVal.toUpperCase().endsWith('ADV')) {
              final baseCode = codeVal.replaceAll(RegExp(r'\s*ADV', caseSensitive: false), '').trim();
              if (imgc == 'Advanced $baseCode') {
                item.courseId = c.id;
                item.courseShortname = c.shortname;
                item.courseType = c.courseType ?? 'async';
                break;
              }
              if (baseCode.startsWith('5.') && imgc == 'Strategic Technologies 1.${baseCode.substring(2)}') {
                item.courseId = c.id;
                item.courseShortname = c.shortname;
                item.courseType = c.courseType ?? 'async';
                break;
              }
              if (baseCode.startsWith('6.') && imgc == 'Strategic Technologies 2.${baseCode.substring(2)}') {
                item.courseId = c.id;
                item.courseShortname = c.shortname;
                item.courseType = c.courseType ?? 'async';
                break;
              }
            } else {
              if (imgc == 'Basic $codeVal') {
                item.courseId = c.id;
                item.courseShortname = c.shortname;
                item.courseType = c.courseType ?? 'async';
                break;
              }
            }
          }
        }
      }

      return item;
    }).toList();

    await isar.writeTxn(() async {
      await isar.courseCatalogItems.putAll(items);
    });

    return items.length;
  }
}
