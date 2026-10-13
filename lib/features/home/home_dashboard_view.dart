import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../settings/providers/app_settings_provider.dart';
import '../sync/models/user.dart';

class HomeDashboardView extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToSync;
  final VoidCallback onNavigateToUsers;

  const HomeDashboardView({
    super.key,
    required this.onNavigateToSync,
    required this.onNavigateToUsers,
  });

  @override
  ConsumerState<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends ConsumerState<HomeDashboardView> {
  bool _isLoading = true;
  List<User> _users = [];
  StreamSubscription<void>? _usersSub;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    final isar = ref.read(isarProvider);
    _usersSub = isar.users.watchLazy().listen((_) {
      _loadUsers();
    });
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      final list = await isar.users.where().findAll();
      if (mounted) {
        setState(() {
          _users = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Helper per estrazione campi personalizzati ---
  String? _getCustomFieldValue(User u, List<String> keywords) {
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

  DateTime? _extractUserDob(User u) {
    return u.effectiveDob;
  }


  int? _calculateAge(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    if (age < 0 || age > 115) return null;
    return age;
  }

  String _normalizeGender(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'Non specificato';
    final g = raw.trim().toLowerCase();
    if (g == 'm' || g == 'male' || g == 'maschio' || g == 'uomo' || g.startsWith('masch')) {
      return 'Maschio';
    }
    if (g == 'f' || g == 'female' || g == 'femmina' || g == 'donna' || g.startsWith('femm')) {
      return 'Femmina';
    }
    if (g == '-' || g == 'null' || g == 'n/a' || g == 'nd') return 'Non specificato';
    return raw.trim();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final lastSyncDate = settings.lastUsersSyncDate;
    final lastSyncStr = (lastSyncDate != null && lastSyncDate.millisecondsSinceEpoch > 0)
        ? DateFormat('dd/MM/yyyy HH:mm').format(lastSyncDate)
        : 'Mai eseguito';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return _buildEmptyState();
    }

    // --- Calcolo Statistiche Utenti ---
    final totalUsers = _users.length;
    final activeUsers = _users.where((u) => u.suspended != true).length;
    final suspendedUsers = _users.where((u) => u.suspended == true).length;
    final confirmedUsers = _users.where((u) => u.confirmed == true).length;

    // Gender breakdown
    final Map<String, int> genderCounts = {};
    // Ages
    final List<int> allAges = [];
    final List<int> maleAges = [];
    final List<int> femaleAges = [];

    // Organizations
    final Map<String, int> orgCounts = {};
    // Course Languages
    final Map<String, int> courseLangCounts = {};
    // Departments
    final Map<String, int> deptCounts = {};

    for (final u in _users) {
      // 1. Gender & Age
      final rawGender = _getCustomFieldValue(u, ['gender', 'sesso', 'genere']);
      final gender = _normalizeGender(rawGender);
      genderCounts[gender] = (genderCounts[gender] ?? 0) + 1;

      final dob = _extractUserDob(u);
      final age = _calculateAge(dob);
      if (age != null) {
        allAges.add(age);
        if (gender == 'Maschio') {
          maleAges.add(age);
        } else if (gender == 'Femmina') {
          femaleAges.add(age);
        }
      }

      // 2. Organization
      final rawOrg = _getCustomFieldValue(u, ['membership', 'organization', 'organizzaz']);
      final orgName = (rawOrg != null && rawOrg.trim().isNotEmpty)
          ? rawOrg.trim()
          : (u.department != null && u.department!.trim().isNotEmpty
              ? u.department!.trim()
              : 'Nessuna organizzazione');
      orgCounts[orgName] = (orgCounts[orgName] ?? 0) + 1;

      // 3. Course Lang
      final rawLang = _getCustomFieldValue(u, ['course lang', 'course_lang', 'prefcourselang', 'pref_course_lang', 'lang']);
      final langCode = (rawLang != null && rawLang.trim().isNotEmpty)
          ? rawLang.trim().toUpperCase()
          : (u.lang != null && u.lang!.trim().isNotEmpty ? u.lang!.trim().toUpperCase() : 'N/D');
      courseLangCounts[langCode] = (courseLangCounts[langCode] ?? 0) + 1;

      // 4. Department
      if (u.department != null && u.department!.trim().isNotEmpty) {
        final dept = u.department!.trim();
        deptCounts[dept] = (deptCounts[dept] ?? 0) + 1;
      }
    }

    final double avgAgeAll = allAges.isNotEmpty ? (allAges.reduce((a, b) => a + b) / allAges.length) : 0.0;
    final double avgAgeMale = maleAges.isNotEmpty ? (maleAges.reduce((a, b) => a + b) / maleAges.length) : 0.0;
    final double avgAgeFemale = femaleAges.isNotEmpty ? (femaleAges.reduce((a, b) => a + b) / femaleAges.length) : 0.0;
    final int minAge = allAges.isNotEmpty ? allAges.reduce(math.min) : 0;
    final int maxAge = allAges.isNotEmpty ? allAges.reduce(math.max) : 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header
                _buildHeader(totalUsers, lastSyncStr),
                const SizedBox(height: 24),

                // Top KPI Summary Cards
                _buildKpiRow(
                  totalUsers: totalUsers,
                  activeUsers: activeUsers,
                  suspendedUsers: suspendedUsers,
                  confirmedUsers: confirmedUsers,
                ),
                const SizedBox(height: 24),

                // Sezione 1: Gender & Age Analytics
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 880;
                    if (isCompact) {
                      return Column(
                        children: [
                          _buildGenderCard(genderCounts, totalUsers),
                          const SizedBox(height: 20),
                          _buildAgeCard(
                            avgAll: avgAgeAll,
                            avgMale: avgAgeMale,
                            avgFemale: avgAgeFemale,
                            totalRecordsWithDob: allAges.length,
                            maleCount: maleAges.length,
                            femaleCount: femaleAges.length,
                            minAge: minAge,
                            maxAge: maxAge,
                          ),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildGenderCard(genderCounts, totalUsers),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 6,
                          child: _buildAgeCard(
                            avgAll: avgAgeAll,
                            avgMale: avgAgeMale,
                            avgFemale: avgAgeFemale,
                            totalRecordsWithDob: allAges.length,
                            maleCount: maleAges.length,
                            femaleCount: femaleAges.length,
                            minAge: minAge,
                            maxAge: maxAge,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Sezione 2: Membership Organization & Course Languages
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 880;
                    if (isCompact) {
                      return Column(
                        children: [
                          _buildDistributionCard(
                            title: 'Membership Organizations',
                            subtitle: 'Distribuzione per ente di appartenenza',
                            icon: Icons.corporate_fare_rounded,
                            iconColor: AppTheme.primaryBlue,
                            counts: orgCounts,
                            total: totalUsers,
                          ),
                          const SizedBox(height: 20),
                          _buildDistributionCard(
                            title: 'Lingue Corso (Course Lang)',
                            subtitle: 'Preferenze linguistiche registrate',
                            icon: Icons.translate_rounded,
                            iconColor: const Color(0xFF0D9488),
                            counts: courseLangCounts,
                            total: totalUsers,
                          ),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDistributionCard(
                            title: 'Membership Organizations',
                            subtitle: 'Distribuzione per ente di appartenenza',
                            icon: Icons.corporate_fare_rounded,
                            iconColor: AppTheme.primaryBlue,
                            counts: orgCounts,
                            total: totalUsers,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildDistributionCard(
                            title: 'Lingue Corso (Course Lang)',
                            subtitle: 'Preferenze linguistiche registrate',
                            icon: Icons.translate_rounded,
                            iconColor: const Color(0xFF0D9488),
                            counts: courseLangCounts,
                            total: totalUsers,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                if (deptCounts.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildDistributionCard(
                    title: 'Dipartimenti Aziendali (Departments)',
                    subtitle: 'Distribuzione dipartimentale degli utenti',
                    icon: Icons.badge_outlined,
                    iconColor: const Color(0xFF4F46E5),
                    counts: deptCounts,
                    total: totalUsers,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader(int totalUsers, String lastSyncStr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard Analitica Utenti',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
              ),
              const SizedBox(height: 6),
              Text(
                'Panoramica demografica, stato account e aggregazioni basate sui $totalUsers utenti sincronizzati • Ultimo sync: $lastSyncStr',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Wrap(
          spacing: 10,
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'Ricarica dati',
              onPressed: _loadUsers,
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            FilledButton.icon(
              onPressed: widget.onNavigateToUsers,
              icon: const Icon(Icons.people_alt_rounded, size: 18),
              label: const Text('Vai alla Lista Utenti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Top KPI Row ---
  Widget _buildKpiRow({
    required int totalUsers,
    required int activeUsers,
    required int suspendedUsers,
    required int confirmedUsers,
  }) {
    final activePct = totalUsers > 0 ? ((activeUsers / totalUsers) * 100).toStringAsFixed(1) : '0';
    final suspendedPct = totalUsers > 0 ? ((suspendedUsers / totalUsers) * 100).toStringAsFixed(1) : '0';
    final confirmedPct = totalUsers > 0 ? ((confirmedUsers / totalUsers) * 100).toStringAsFixed(1) : '0';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;
        final cardWidth = isCompact ? (constraints.maxWidth - 12) / 2 : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildKpiCard(
                title: 'TOTALE UTENTI',
                value: '$totalUsers',
                badgeText: '100% Censiti',
                badgeColor: AppTheme.primaryBlue,
                icon: Icons.people_alt_rounded,
                iconColor: AppTheme.primaryBlue,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildKpiCard(
                title: 'UTENTI ATTIVI',
                value: '$activeUsers',
                badgeText: '$activePct% Attivi',
                badgeColor: const Color(0xFF16A34A),
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF16A34A),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildKpiCard(
                title: 'UTENTI SOSPESI',
                value: '$suspendedUsers',
                badgeText: '$suspendedPct% Sospesi',
                badgeColor: Colors.red.shade600,
                icon: Icons.block_flipped,
                iconColor: Colors.red.shade600,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildKpiCard(
                title: 'CONFERMATI',
                value: '$confirmedUsers',
                badgeText: '$confirmedPct% Verificati',
                badgeColor: const Color(0xFF0284C7),
                icon: Icons.verified_user_outlined,
                iconColor: const Color(0xFF0284C7),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(18),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
            ),
          ),
        ],
      ),
    );
  }

  // --- Gender Card (con Grafico a Torta / Donut Chart) ---
  Widget _buildGenderCard(Map<String, int> genderCounts, int totalUsers) {
    final maleCount = genderCounts['Maschio'] ?? 0;
    final femaleCount = genderCounts['Femmina'] ?? 0;
    final otherCount = totalUsers - (maleCount + femaleCount);

    final List<_PieData> slices = [
      _PieData(
        label: 'Maschi',
        count: maleCount,
        color: const Color(0xFF2563EB), // Blu
        icon: Icons.male_rounded,
      ),
      _PieData(
        label: 'Femmine',
        count: femaleCount,
        color: const Color(0xFFDB2777), // Rosa / Magenta
        icon: Icons.female_rounded,
      ),
      _PieData(
        label: 'Non specificato',
        count: math.max(0, otherCount),
        color: const Color(0xFF94A3B8), // Grigio
        icon: Icons.help_outline_rounded,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withAlpha(16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pie_chart_rounded, color: AppTheme.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribuzione per Genere (Gender)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    'Ripartizione percentuale utenti maschili e femminili',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Donut Chart + Legend
          Row(
            children: [
              // Grafico a Ciambella
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(150, 150),
                      painter: _DonutChartPainter(
                        slices: slices,
                        total: totalUsers.toDouble(),
                        strokeWidth: 26,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$totalUsers',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const Text(
                          'Utenti',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // Dettaglio Legenda
              Expanded(
                child: Column(
                  children: slices.map((s) {
                    final pct = totalUsers > 0 ? (s.count / totalUsers * 100).toStringAsFixed(1) : '0';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: s.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s.label,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${s.count}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '($pct%)',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Age Analytics Card ---
  Widget _buildAgeCard({
    required double avgAll,
    required double avgMale,
    required double avgFemale,
    required int totalRecordsWithDob,
    required int maleCount,
    required int femaleCount,
    required int minAge,
    required int maxAge,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withAlpha(18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cake_outlined, color: Color(0xFF7C3AED), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analisi Età Media Utenti',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        'Calcolata in base alla data di nascita (DoB)',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              if (totalRecordsWithDob > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Range: $minAge - $maxAge anni',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          if (totalRecordsWithDob == 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.amber.shade800, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nessun utente ha una data di nascita valida registrata nei campi personalizzati.',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // KPI principale Età Globale
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_outline, color: AppTheme.primaryBlue, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ETÀ MEDIA COMPLESSIVA',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                        ),
                        Text(
                          '${avgAll.toStringAsFixed(1)} anni',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'su $totalRecordsWithDob profili',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Confronto Maschi vs Femmine
            Row(
              children: [
                // Maschi
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.male_rounded, color: Color(0xFF2563EB), size: 18),
                            const SizedBox(width: 6),
                            const Text(
                              'Maschi',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                            ),
                            const Spacer(),
                            Text(
                              '$maleCount rec.',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF60A5FA), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          avgMale > 0 ? '${avgMale.toStringAsFixed(1)} anni' : 'N/D',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Femmine
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.female_rounded, color: Color(0xFFDB2777), size: 18),
                            const SizedBox(width: 6),
                            const Text(
                              'Femmine',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF831843)),
                            ),
                            const Spacer(),
                            Text(
                              '$femaleCount rec.',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFF472B6), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          avgFemale > 0 ? '${avgFemale.toStringAsFixed(1)} anni' : 'N/D',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF9D174D)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // --- Card Distribuzione a Barre (Organizations / Course Lang) ---
  Widget _buildDistributionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Map<String, int> counts,
    required int total,
  }) {
    final sortedEntries = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final displayEntries = sortedEntries.take(7).toList();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${counts.length} categorie',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (displayEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text('Nessun dato registrato', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ),
            )
          else
            Column(
              children: displayEntries.map((e) {
                final ratio = total > 0 ? (e.value / total) : 0.0;
                final pct = (ratio * 100).toStringAsFixed(1);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              e.key,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${e.value}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '($pct%)',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 7,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // --- Stato Vuoto ---
  Widget _buildEmptyState() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withAlpha(16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.insights_rounded, size: 54, color: AppTheme.primaryBlue),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nessun Dato Utenti Disponibile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Il database locale non contiene utenti sincronizzati. Avvia la prima sincronizzazione per generare metriche e grafici analitici.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: widget.onNavigateToSync,
                  icon: const Icon(Icons.sync_rounded),
                  label: const Text('Vai al menu Sync', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Modello Dati Fetta Grafico ---
class _PieData {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  _PieData({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });
}

// --- Painter Grafico a Ciambella ---
class _DonutChartPainter extends CustomPainter {
  final List<_PieData> slices;
  final double total;
  final double strokeWidth;

  _DonutChartPainter({
    required this.slices,
    required this.total,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;

    for (final slice in slices) {
      if (slice.count <= 0) continue;
      final sweepAngle = (slice.count / total) * 2 * math.pi;

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.total != total || oldDelegate.slices != slices;
  }
}
