import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/universal_io.dart';
import '../../core/db/isar_provider.dart';
import '../../core/theme/app_theme.dart';
import '../settings/providers/app_settings_provider.dart';
import 'models/category.dart';
import 'models/user.dart';

class SyncSettingsView extends ConsumerStatefulWidget {
  const SyncSettingsView({super.key});

  @override
  ConsumerState<SyncSettingsView> createState() => _SyncSettingsViewState();
}

class _SyncSettingsViewState extends ConsumerState<SyncSettingsView> {
  bool _isSyncing = false;
  int _localUsersCount = 0;
  String? _syncErrorMessage;
  String? _syncSuccessMessage;
  StreamSubscription<void>? _usersSub;

  bool _isCategoriesSyncing = false;
  int _localCategoriesCount = 0;
  String? _categoriesSyncErrorMessage;
  String? _categoriesSyncSuccessMessage;
  StreamSubscription<void>? _categoriesSub;

  @override
  void initState() {
    super.initState();
    _refreshLocalCount();
    final isar = ref.read(isarProvider);
    _usersSub = isar.users.watchLazy().listen((_) {
      _refreshLocalCount();
    });
    _categoriesSub = isar.categories.watchLazy().listen((_) {
      _refreshLocalCount();
    });
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    _categoriesSub?.cancel();
    super.dispose();
  }

  Future<void> _refreshLocalCount() async {
    final isar = ref.read(isarProvider);
    final count = await isar.users.count();
    final catCount = await isar.categories.count();
    if (mounted) {
      setState(() {
        _localUsersCount = count;
        _localCategoriesCount = catCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final lastSyncText = settings.lastUsersSyncDate != null &&
            settings.lastUsersSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastUsersSyncDate!)
        : 'Mai eseguito';
    final lastCategoriesSyncText = settings.lastCategoriesSyncDate != null &&
            settings.lastCategoriesSyncDate!.millisecondsSinceEpoch > 0
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(settings.lastCategoriesSyncDate!)
        : 'Mai eseguito';

    final totalRecords = _localUsersCount + _localCategoriesCount;
    final isAnySyncing = _isSyncing || _isCategoriesSyncing;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: isAnySyncing ? null : _refreshLocalCount,
                    tooltip: 'Ricarica metriche locali',
                  ),
                ),
                const SizedBox(height: 12),

                // Card Riepilogo Globale
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.sync_alt_rounded, color: AppTheme.primaryBlue, size: 30),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STATO SINCRONIZZAZIONE',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '2 collezioni API collegate • $totalRecords record totali in locale',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: isAnySyncing ? null : _syncAll,
                          icon: isAnySyncing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.sync_rounded),
                          label: Text(
                            isAnySyncing ? 'Sincronizzazione...' : 'Sincronizza Tutti',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lista Collezioni Sincronizzabili
                const Text(
                  'COLLEZIONI DISPONIBILI',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),

                _buildSyncListItem(
                  icon: Icons.people_alt_outlined,
                  iconColor: AppTheme.primaryBlue,
                  title: 'Utenti (Users)',
                  endpoint: '/users',
                  description: 'Scarica l\'elenco utenti completo con attributi anagrafici, ruoli e customfields.',
                  lastSyncText: lastSyncText,
                  localCountText: '$_localUsersCount utenti',
                  isSyncing: _isSyncing,
                  onSync: _syncUsers,
                  errorMessage: _syncErrorMessage,
                  successMessage: _syncSuccessMessage,
                ),
                const SizedBox(height: 14),

                _buildSyncListItem(
                  icon: Icons.category_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Categorie Corsi (Categories)',
                  endpoint: '/categories',
                  description: 'Scarica le categorie di corsi con moduli, descrizioni, immagini e gerarchia.',
                  lastSyncText: lastCategoriesSyncText,
                  localCountText: '$_localCategoriesCount categorie',
                  isSyncing: _isCategoriesSyncing,
                  onSync: _syncCategories,
                  errorMessage: _categoriesSyncErrorMessage,
                  successMessage: _categoriesSyncSuccessMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String endpoint,
    required String description,
    required String lastSyncText,
    required String localCountText,
    required bool isSyncing,
    required VoidCallback onSync,
    String? errorMessage,
    String? successMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 620;

              final infoSection = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                endpoint,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Ultimo sync: $lastSyncText',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.storage_rounded, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 6),
                                  Text(
                                    localCountText,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: iconColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final actionButton = ElevatedButton.icon(
                onPressed: isSyncing ? null : onSync,
                icon: isSyncing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_rounded, size: 18),
                label: Text(
                  isSyncing ? 'Sincronizzazione...' : 'Sincronizza',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoSection,
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: actionButton),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: infoSection),
                  const SizedBox(width: 20),
                  actionButton,
                ],
              );
            },
          ),

          // Banner Messaggi di Esito
          if (errorMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (successMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      successMessage,
                      style: TextStyle(color: Colors.green.shade900, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _syncAll() async {
    await _syncUsers();
    await _syncCategories();
  }

  Future<void> _syncUsers() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSyncing = true;
      _syncErrorMessage = null;
      _syncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/users';
      } else {
        fullUrl += 'users';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> usersJsonList = [];

        if (decoded is List) {
          usersJsonList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('username')) {
            usersJsonList = [map];
          } else if (map['users'] is List) {
            usersJsonList = map['users'] as List;
          } else if (map['data'] is List) {
            usersJsonList = map['data'] as List;
          } else if (map['elements'] is List) {
            usersJsonList = map['elements'] as List;
          } else if (map['records'] is List) {
            usersJsonList = map['records'] as List;
          } else if (map['results'] is List) {
            usersJsonList = map['results'] as List;
          } else {
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                usersJsonList = v;
                break;
              }
            }
          }
        }

        final List<User> usersList = [];
        for (final item in usersJsonList) {
          if (item is Map) {
            try {
              usersList.add(User.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync Users] Errore parsing user: $e');
            }
          }
        }

        if (usersList.isEmpty) {
          setState(() {
            _syncErrorMessage = 'Nessun record utente valido estratto dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.users.putAll(usersList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateUsersSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _syncSuccessMessage = 'Sincronizzazione completata con successo: ${usersList.length} utenti salvati nel database!';
        });
      } else {
        setState(() {
          _syncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _syncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _syncCategories() async {
    final settings = ref.read(appSettingsProvider);
    final baseUrl = settings.apiBaseUrl.trim();
    final username = settings.apiUsername.trim();
    final password = settings.apiPassword;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura prima il Base URL nel menu Impostazioni -> API SERVER.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCategoriesSyncing = true;
      _categoriesSyncErrorMessage = null;
      _categoriesSyncSuccessMessage = null;
    });

    try {
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/')) {
        fullUrl += '/categories';
      } else {
        fullUrl += 'categories';
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);

      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        List<dynamic> categoriesJsonList = [];

        if (decoded is List) {
          categoriesJsonList = decoded;
        } else if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          if (map.containsKey('name') || map.containsKey('idnumber')) {
            categoriesJsonList = [map];
          } else if (map['categories'] is List) {
            categoriesJsonList = map['categories'] as List;
          } else if (map['data'] is List) {
            categoriesJsonList = map['data'] as List;
          } else if (map['elements'] is List) {
            categoriesJsonList = map['elements'] as List;
          } else if (map['records'] is List) {
            categoriesJsonList = map['records'] as List;
          } else if (map['results'] is List) {
            categoriesJsonList = map['results'] as List;
          } else {
            for (final v in map.values) {
              if (v is List && v.isNotEmpty && v.first is Map) {
                categoriesJsonList = v;
                break;
              }
            }
          }
        }

        final List<Category> categoriesList = [];
        for (final item in categoriesJsonList) {
          if (item is Map) {
            try {
              categoriesList.add(Category.fromJson(Map<String, dynamic>.from(item)));
            } catch (e) {
              debugPrint('[Sync Categories] Errore parsing item: $e');
            }
          }
        }

        if (categoriesList.isEmpty) {
          setState(() {
            _categoriesSyncErrorMessage = 'Nessuna categoria valida estratta dalla risposta del server.\n'
                'Risposta ricevuta: ${responseBody.length > 250 ? '${responseBody.substring(0, 250)}...' : responseBody}';
          });
          return;
        }

        final isar = ref.read(isarProvider);
        await isar.writeTxn(() async {
          await isar.categories.putAll(categoriesList);
        });

        final now = DateTime.now();
        await ref.read(appSettingsProvider.notifier).updateCategoriesSyncDate(now);
        await _refreshLocalCount();

        setState(() {
          _categoriesSyncSuccessMessage = 'Sincronizzazione completata con successo: ${categoriesList.length} categorie salvate nel database!';
        });
      } else {
        setState(() {
          _categoriesSyncErrorMessage = 'Risposta HTTP ${response.statusCode}: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _categoriesSyncErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isCategoriesSyncing = false);
      }
    }
  }
}
