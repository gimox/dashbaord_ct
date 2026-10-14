import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/proxy_service.dart';
import '../badges/badges_list_view.dart';
import '../categories/categories_list_view.dart';
import '../course_info/course_info_list_view.dart';
import '../courses/courses_list_view.dart';
import '../database/db_settings_view.dart';
import '../enrollments/enrollments_list_view.dart';
import '../settings/models/app_settings.dart';
import '../settings/providers/app_settings_provider.dart';
import '../settings/settings_view.dart';
import '../stats/stat_mdl_list_view.dart';
import '../stats/user_course_stats_view.dart';
import '../sync/providers/global_sync_provider.dart';
import '../sync/sync_view.dart';
import '../users/users_list_view.dart';
import 'home_dashboard_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;
  bool _isSettingsMenuExpanded = true;

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Gestione Utenti (Users)';
      case 7:
        return 'Gestione Corsi (Courses)';
      case 6:
        return 'Gestione Categorie';
      case 8:
        return 'Gestione Badges (Badge Users)';
      case 9:
        return 'Gestione Course Info (Sezioni & Moduli)';
      case 10:
        return 'Statistiche (stat_mdl)';
      case 11:
        return 'Vista per Utente';
      case 12:
        return 'Gestione Iscrizioni (user_course_enrolled)';
      case 2:
        return 'Impostazioni Rete & Proxy';
      case 3:
        return 'Impostazioni API SERVER';
      case 4:
        return 'Sincronizzazione Dati';
      case 5:
        return 'Gestione Database Locale (Isar)';
      default:
        return 'Dashboard';
    }
  }

  String _getSubtitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Panoramica delle metriche aziendali e stato del sistema.';
      case 1:
        return 'Elenco tabellare degli utenti sincronizzati dal server API.';
      case 7:
        return 'Catalogo completo dei corsi, percorsi formativi e modalità di erogazione.';
      case 6:
        return 'Organizzazione dei moduli, percorsi didattici e gerarchia dei corsi nel catalogo.';
      case 8:
        return 'Elenco e monitoraggio dei badge e certificazioni assegnate agli utenti.';
      case 9:
        return 'Catalogo delle sezioni didattiche, moduli attività, risorse e impostazioni di tracciamento.';
      case 10:
        return 'Monitoraggio avanzamento moduli didattici, tracking SCORM e attività utenti.';
      case 11:
        return 'Statistiche aggregate per utente e corso con avanzamento moduli e completamenti.';
      case 12:
        return 'Elenco iscrizioni degli utenti ai corsi con dettagli anagrafici e del catalogo.';
      case 2:
        return 'Configurazione del proxy aziendale, rilevamento automatico PAC e bypass SSL.';
      case 3:
        return 'Parametri endpoint API, autenticazione HTTP e test di connessione.';
      case 4:
        return 'Allinea le collezioni del server API remoto con il database locale Isar.';
      case 5:
        return 'Monitora le tabelle registrate, il numero di record e gestisci il reset delle entità.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 800;
        final collapsed = _isSidebarCollapsed || isCompact;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: Row(
            children: [
              // SIDEBAR LATERALE
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: collapsed ? 76 : 240,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(color: Colors.grey.shade200)),
                ),
                child: OverflowBox(
                  minWidth: collapsed ? 76 : 240,
                  maxWidth: collapsed ? 76 : 240,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: collapsed ? 76 : 240,
                    child: Column(
                      children: [
                    // Header Sidebar con Logo e Toggle
                    Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!collapsed)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  height: 36,
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.dashboard_customize_rounded, color: AppTheme.primaryBlue, size: 28),
                                      SizedBox(width: 8),
                                      Text(
                                        'CyberProTrain',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          IconButton(
                            icon: Icon(collapsed ? Icons.menu : Icons.menu_open, color: Colors.grey.shade700),
                            onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                            tooltip: collapsed ? 'Espandi menu' : 'Comprimi menu',
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Voci di Menu Principali
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildNavItem(
                              index: 0,
                              icon: Icons.home_outlined,
                              selectedIcon: Icons.home,
                              title: 'Home',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 1,
                              icon: Icons.people_alt_outlined,
                              selectedIcon: Icons.people_alt,
                              title: 'Users',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 7,
                              icon: Icons.school_outlined,
                              selectedIcon: Icons.school_rounded,
                              title: 'Courses',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 6,
                              icon: Icons.category_outlined,
                              selectedIcon: Icons.category_rounded,
                              title: 'Categories',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 8,
                              icon: Icons.military_tech_outlined,
                              selectedIcon: Icons.military_tech_rounded,
                              title: 'Badges',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 9,
                              icon: Icons.layers_outlined,
                              selectedIcon: Icons.layers_rounded,
                              title: 'Course Info',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 10,
                              icon: Icons.analytics_outlined,
                              selectedIcon: Icons.analytics_rounded,
                              title: 'Statistiche',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 11,
                              icon: Icons.person_pin_outlined,
                              selectedIcon: Icons.person_pin_rounded,
                              title: 'Vista per utente',
                              isCollapsed: collapsed,
                            ),
                            _buildNavItem(
                              index: 12,
                              icon: Icons.how_to_reg_outlined,
                              selectedIcon: Icons.how_to_reg_rounded,
                              title: 'Iscrizioni',
                              isCollapsed: collapsed,
                            ),

                            const SizedBox(height: 8),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            const SizedBox(height: 8),

                            if (collapsed) ...[
                              // In modalità icon-only: icone dirette per i sottomenu
                              _buildNavItem(
                                index: 4,
                                icon: Icons.sync_rounded,
                                selectedIcon: Icons.sync,
                                title: 'Sync',
                                isCollapsed: true,
                              ),
                              _buildNavItem(
                                index: 2,
                                icon: Icons.lan_outlined,
                                selectedIcon: Icons.lan,
                                title: 'Rete & Proxy',
                                isCollapsed: true,
                              ),
                              _buildNavItem(
                                index: 3,
                                icon: Icons.api_outlined,
                                selectedIcon: Icons.api,
                                title: 'API SERVER',
                                isCollapsed: true,
                              ),
                              _buildNavItem(
                                index: 5,
                                icon: Icons.dns_outlined,
                                selectedIcon: Icons.dns_rounded,
                                title: 'Database (DB)',
                                isCollapsed: true,
                              ),
                            ] else ...[
                              // Voce Principale: Impostazioni con Sotto-Menu
                              _buildParentSettingsItem(),

                              if (_isSettingsMenuExpanded) ...[
                                _buildSubNavItem(
                                  index: 4,
                                  icon: Icons.sync_rounded,
                                  selectedIcon: Icons.sync,
                                  title: 'Sync',
                                ),
                                _buildSubNavItem(
                                  index: 2,
                                  icon: Icons.lan_outlined,
                                  selectedIcon: Icons.lan,
                                  title: 'Rete & Proxy',
                                ),
                                _buildSubNavItem(
                                  index: 3,
                                  icon: Icons.api_outlined,
                                  selectedIcon: Icons.api,
                                  title: 'API SERVER',
                                ),
                                _buildSubNavItem(
                                  index: 5,
                                  icon: Icons.dns_outlined,
                                  selectedIcon: Icons.dns_rounded,
                                  title: 'Database (DB)',
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Stato Proxy in basso
                    if (!collapsed)
                      Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              ProxyService.resolvedProxy != null ? Icons.wifi_protected_setup : Icons.wifi,
                              size: 18,
                              color: ProxyService.resolvedProxy != null ? Colors.green.shade700 : Colors.grey,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  ProxyService.resolvedProxy != null ? 'Proxy attivo' : 'Rete standard',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

              // CONTENUTO PRINCIPALE
              Expanded(
                child: Column(
                  children: [
                    // TopBar
                    Container(
                      height: 76,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getTitle(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (_getSubtitle().isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    _getSubtitle(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          HeaderSyncButton(
                            onNavigateToApiSettings: () => setState(() => _selectedIndex = 3),
                          ),
                        ],
                      ),
                    ),

                    // Body delle Viste
                    Expanded(
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: [
                          HomeDashboardView(
                            onNavigateToSync: () => setState(() => _selectedIndex = 4),
                            onNavigateToUsers: () => setState(() => _selectedIndex = 1),
                            onNavigateToUserStats: () => setState(() => _selectedIndex = 11),
                            onNavigateToEnrollments: () => setState(() => _selectedIndex = 12),
                          ),
                          const UsersListView(),
                          const NetworkSettingsView(),
                          const ApiSettingsView(),
                          const SyncSettingsView(),
                          const DbSettingsView(),
                          const CategoriesListView(),
                          const CoursesListView(),
                          const BadgesListView(),
                          const CourseInfoListView(),
                          const StatMdlListView(),
                          const UserCourseStatsView(),
                          const EnrollmentsListView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Voce Menu Standard
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required bool isCollapsed,
  }) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Tooltip(
        message: isCollapsed ? title : '',
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue.withAlpha(20) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(isSelected ? selectedIcon : icon, color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade700, size: 22),
                if (!isCollapsed)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Voce Genitore "Impostazioni" espandibile
  Widget _buildParentSettingsItem() {
    final isChildSelected = _selectedIndex >= 2 && _selectedIndex <= 5;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _isSettingsMenuExpanded = !_isSettingsMenuExpanded;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isChildSelected && !_isSettingsMenuExpanded ? AppTheme.primaryBlue.withAlpha(15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: isChildSelected ? AppTheme.primaryBlue : Colors.grey.shade700,
                size: 22,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Impostazioni',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isChildSelected ? FontWeight.bold : FontWeight.normal,
                        color: isChildSelected ? AppTheme.primaryBlue : Colors.grey.shade800,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              Icon(
                _isSettingsMenuExpanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sotto-voce indentata per Impostazioni
  Widget _buildSubNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
  }) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 2, bottom: 2),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue.withAlpha(25) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade600,
                size: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade700,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSyncButton extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToApiSettings;

  const HeaderSyncButton({
    super.key,
    this.onNavigateToApiSettings,
  });

  @override
  ConsumerState<HeaderSyncButton> createState() => _HeaderSyncButtonState();
}

class _HeaderSyncButtonState extends ConsumerState<HeaderSyncButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  DateTime? _resolveLastSyncDate(AppSettings settings, GlobalSyncState syncState) {
    final candidates = [
      syncState.lastSyncTime,
      settings.lastSyncTime,
      settings.lastUsersSyncDate,
      settings.lastCategoriesSyncDate,
      settings.lastCoursesSyncDate,
      settings.lastBadgesUsersSyncDate,
      settings.lastCourseInfoSyncDate,
      settings.lastMergeWebexUsersSyncDate,
      settings.lastStatMdlSyncDate,
      settings.lastUserCourseEnrolledSyncDate,
    ].whereType<DateTime>().toList();

    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => b.compareTo(a));
    return candidates.first;
  }

  Widget _buildButton(BuildContext context, bool isApiConfigured, GlobalSyncState syncState) {
    if (syncState.isSyncing) {
      return Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A),
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: const Icon(Icons.sync_rounded, color: Colors.white, size: 15),
            ),
            const SizedBox(width: 8),
            Text(
              syncState.currentOperation.isNotEmpty
                  ? syncState.currentOperation
                  : 'Sincronizzazione...',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(
                value: syncState.progress > 0 ? syncState.progress : null,
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.white24,
              ),
            ),
          ],
        ),
      );
    }

    if (!isApiConfigured) {
      return Tooltip(
        message: 'Configura Base URL, Username e Password in Impostazioni API SERVER per abilitare la sincronizzazione.',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onNavigateToApiSettings,
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sync_disabled_rounded, size: 15, color: Colors.grey.shade500),
                  const SizedBox(width: 7),
                  Text(
                    'Sync disabilitato (API non configurate)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ref.read(globalSyncProvider.notifier).syncAll(),
        borderRadius: BorderRadius.circular(9),
        child: Ink(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withAlpha(35),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sync_rounded, color: Colors.white, size: 15),
              SizedBox(width: 7),
              Text(
                'Sincronizza Dati',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final syncState = ref.watch(globalSyncProvider);

    final isApiConfigured = settings.apiBaseUrl.trim().isNotEmpty &&
        settings.apiUsername.trim().isNotEmpty &&
        settings.apiPassword.trim().isNotEmpty;

    if (syncState.isSyncing) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else {
      if (_rotationController.isAnimating) {
        _rotationController.stop();
        _rotationController.reset();
      }
    }

    ref.listen<GlobalSyncState>(globalSyncProvider, (previous, next) {
      if (previous?.isSyncing == true && !next.isSyncing) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      next.errorMessage!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (next.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      next.successMessage!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    });

    final lastSyncDate = _resolveLastSyncDate(settings, syncState);
    final String lastSyncText = syncState.isSyncing
        ? 'Sincronizzazione in corso...'
        : (lastSyncDate != null
            ? 'Ultimo sync: ${DateFormat('dd/MM/yyyy HH:mm').format(lastSyncDate)}'
            : 'Ultimo sync: Mai eseguito');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(context, isApiConfigured, syncState),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 11, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              lastSyncText,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
