import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/proxy_service.dart';
import '../categories/categories_list_view.dart';
import '../database/db_settings_view.dart';
import '../settings/settings_view.dart';
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
      case 6:
        return 'Gestione Categorie';
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
      case 6:
        return 'Organizzazione dei moduli, percorsi didattici e gerarchia dei corsi nel catalogo.';
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
                      index: 6,
                      icon: Icons.category_outlined,
                      selectedIcon: Icons.category_rounded,
                      title: 'Categories',
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

                    const Spacer(),

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
                          const Chip(
                            avatar: Icon(Icons.circle, color: Colors.green, size: 10),
                            label: Text('Modalità Standalone Locale', style: TextStyle(fontSize: 12)),
                            backgroundColor: Color(0xFFF5F5F5),
                            side: BorderSide.none,
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
                          ),
                          const UsersListView(),
                          const NetworkSettingsView(),
                          const ApiSettingsView(),
                          const SyncSettingsView(),
                          const DbSettingsView(),
                          const CategoriesListView(),
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
