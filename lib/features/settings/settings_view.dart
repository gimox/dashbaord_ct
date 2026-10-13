import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/universal_io.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/proxy_service.dart';
import 'models/app_settings.dart';
import 'providers/app_settings_provider.dart';

// VISTA: IMPOSTAZIONI RETE & PROXY
class NetworkSettingsView extends ConsumerStatefulWidget {
  const NetworkSettingsView({super.key});

  @override
  ConsumerState<NetworkSettingsView> createState() => _NetworkSettingsViewState();
}

class _NetworkSettingsViewState extends ConsumerState<NetworkSettingsView> {
  final _proxyUrlController = TextEditingController();
  final _proxyUsernameController = TextEditingController();
  final _proxyPasswordController = TextEditingController();

  bool _proxyEnabled = false;
  bool _proxyAutoConfig = true;
  bool _bypassSslVerification = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final settings = ref.read(appSettingsProvider);
      _proxyEnabled = settings.proxyEnabled;
      _proxyAutoConfig = settings.proxyAutoConfig;
      _bypassSslVerification = settings.bypassSslVerification;
      _proxyUrlController.text = settings.customProxyUrl;
      _proxyUsernameController.text = settings.proxyUsername;
      _proxyPasswordController.text = settings.proxyPassword;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _proxyUrlController.dispose();
    _proxyUsernameController.dispose();
    _proxyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppSettings>(appSettingsProvider, (previous, next) {
      if (_proxyEnabled != next.proxyEnabled ||
          _proxyAutoConfig != next.proxyAutoConfig ||
          _bypassSslVerification != next.bypassSslVerification) {
        setState(() {
          _proxyEnabled = next.proxyEnabled;
          _proxyAutoConfig = next.proxyAutoConfig;
          _bypassSslVerification = next.bypassSslVerification;
        });
      }
      if (_proxyUrlController.text != next.customProxyUrl) {
        _proxyUrlController.text = next.customProxyUrl;
      }
      if (_proxyUsernameController.text != next.proxyUsername) {
        _proxyUsernameController.text = next.proxyUsername;
      }
      if (_proxyPasswordController.text != next.proxyPassword) {
        _proxyPasswordController.text = next.proxyPassword;
      }
    });

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

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONFIGURAZIONE PROXY',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Abilita Proxy di Rete', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Instrada tutte le richieste HTTP/HTTPS tramite un server proxy aziendale.'),
                          value: _proxyEnabled,
                          onChanged: (val) => setState(() => _proxyEnabled = val),
                        ),
                        if (_proxyEnabled) ...[
                          const Divider(height: 32),
                          const Text('Modalità di Rilevamento', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Automatica (PAC / Sistema)'),
                                  subtitle: const Text('Rileva il proxy dal sistema operativo o script PAC'),
                                  value: true,
                                  // ignore: deprecated_member_use
                                  groupValue: _proxyAutoConfig,
                                  // ignore: deprecated_member_use
                                  onChanged: (val) => setState(() => _proxyAutoConfig = val!),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Manuale'),
                                  subtitle: const Text('Specifica host, porta e credenziali dedicate'),
                                  value: false,
                                  // ignore: deprecated_member_use
                                  groupValue: _proxyAutoConfig,
                                  // ignore: deprecated_member_use
                                  onChanged: (val) => setState(() => _proxyAutoConfig = val!),
                                ),
                              ),
                            ],
                          ),
                          if (!_proxyAutoConfig) ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: _proxyUrlController,
                              decoration: InputDecoration(
                                labelText: 'Server Proxy (host:porta)',
                                hintText: 'es: proxy.azienda.local:8080',
                                prefixIcon: const Icon(Icons.dns_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _proxyUsernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username (opzionale)',
                                      prefixIcon: const Icon(Icons.person_outline),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _proxyPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password (opzionale)',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                        const Divider(height: 40),
                        const Text(
                          'SICUREZZA & CERTIFICATI',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Bypass Controllo SSL (SSL Inspection)', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Consente la comunicazione anche in presenza di certificati aziendali interni o proxy man-in-the-middle.'),
                          value: _bypassSslVerification,
                          onChanged: (val) => setState(() => _bypassSslVerification = val),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _saveSettings,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Salva ed Applica Impostazioni', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> _saveSettings() async {
    await ref.read(appSettingsProvider.notifier).updateNetworkSettings(
      proxyEnabled: _proxyEnabled,
      proxyAutoConfig: _proxyAutoConfig,
      customProxyUrl: _proxyUrlController.text.trim(),
      bypassSslVerification: _bypassSslVerification,
      proxyUsername: _proxyUsernameController.text.trim(),
      proxyPassword: _proxyPasswordController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ProxyService.resolvedProxy != null
                ? 'Proxy applicato: ${ProxyService.resolvedProxy}'
                : 'Impostazioni di rete salvate con successo!',
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// VISTA: IMPOSTAZIONI API SERVER
class ApiSettingsView extends ConsumerStatefulWidget {
  const ApiSettingsView({super.key});

  @override
  ConsumerState<ApiSettingsView> createState() => _ApiSettingsViewState();
}

class _ApiSettingsViewState extends ConsumerState<ApiSettingsView> {
  final _apiBaseUrlController = TextEditingController();
  final _apiUsernameController = TextEditingController();
  final _apiPasswordController = TextEditingController();
  final _apiTestEndpointController = TextEditingController();

  bool _obscureApiPassword = true;
  bool _isInitialized = false;

  // Stato chiamata di Test
  bool _isTesting = false;
  int? _testStatusCode;
  List<String>? _testElements;
  String? _testRawJson;
  String? _testErrorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final settings = ref.read(appSettingsProvider);
      _apiBaseUrlController.text = settings.apiBaseUrl;
      _apiUsernameController.text = settings.apiUsername;
      _apiPasswordController.text = settings.apiPassword;
      _apiTestEndpointController.text = settings.apiTestEndpoint.isNotEmpty
          ? settings.apiTestEndpoint
          : 'elements';
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _apiBaseUrlController.dispose();
    _apiUsernameController.dispose();
    _apiPasswordController.dispose();
    _apiTestEndpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppSettings>(appSettingsProvider, (previous, next) {
      if (_apiBaseUrlController.text != next.apiBaseUrl) {
        _apiBaseUrlController.text = next.apiBaseUrl;
      }
      if (_apiUsernameController.text != next.apiUsername) {
        _apiUsernameController.text = next.apiUsername;
      }
      if (_apiPasswordController.text != next.apiPassword) {
        _apiPasswordController.text = next.apiPassword;
      }
      if (_apiTestEndpointController.text != next.apiTestEndpoint &&
          next.apiTestEndpoint.isNotEmpty) {
        _apiTestEndpointController.text = next.apiTestEndpoint;
      }
    });

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


                // Card Parametri Connessione
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PARAMETRI DI CONNESSIONE API',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'I parametri configurati vengono salvati nel database locale e ricaricati automaticamente ad ogni avvio.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),

                        // Base URL
                        TextField(
                          controller: _apiBaseUrlController,
                          decoration: InputDecoration(
                            labelText: 'Base URL',
                            hintText: 'es: https://api.cyberprotrain.example.com',
                            prefixIcon: const Icon(Icons.link_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Username e Password responsive
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow = constraints.maxWidth < 600;
                            final usernameField = TextField(
                              controller: _apiUsernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'es: admin',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );

                            final passwordField = TextField(
                              controller: _apiPasswordController,
                              obscureText: _obscureApiPassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureApiPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                  onPressed: () => setState(() => _obscureApiPassword = !_obscureApiPassword),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );

                            if (isNarrow) {
                              return Column(
                                children: [
                                  usernameField,
                                  const SizedBox(height: 16),
                                  passwordField,
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: usernameField),
                                const SizedBox(width: 16),
                                Expanded(child: passwordField),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 28),
                        const Divider(),
                        const SizedBox(height: 20),

                        // Sezione Test Endpoint
                        const Text(
                          'TEST ENDPOINT & CONNETTIVITÀ',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Specifica l\'endpoint di verifica da concatenare al Base URL ed esegui la chiamata di test con autenticazione.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 16),

                        // Input Test EndpointUrl + Pulsante TEST
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow = constraints.maxWidth < 600;
                            final endpointField = TextField(
                              controller: _apiTestEndpointController,
                              decoration: InputDecoration(
                                labelText: 'Test EndPointUrl',
                                hintText: 'es: elements oppure /elements',
                                prefixIcon: const Icon(Icons.alt_route_rounded),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );

                            final testButton = SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _isTesting ? null : _runApiTest,
                                icon: _isTesting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Icon(Icons.play_arrow_rounded),
                                label: Text(
                                  _isTesting ? 'Verifica in corso...' : 'TEST',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                ),
                              ),
                            );

                            if (isNarrow) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  endpointField,
                                  const SizedBox(height: 12),
                                  testButton,
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: endpointField),
                                const SizedBox(width: 16),
                                testButton,
                              ],
                            );
                          },
                        ),

                        // Risultato del TEST
                        if (_testErrorMessage != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Errore durante il test di connessione:',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _testErrorMessage!,
                                        style: TextStyle(fontSize: 13, color: Colors.red.shade800),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (_testElements != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 22),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Test Completato con Successo! (Status: $_testStatusCode OK)',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900, fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Chip(
                                      label: Text(
                                        '${_testElements!.length} elementi',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      backgroundColor: Colors.green.shade100,
                                      side: BorderSide.none,
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                const Text(
                                  'Elementi restituiti dalla risposta JSON:',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _testElements!.map((elem) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.green.shade300),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.code_rounded, size: 14, color: Colors.teal.shade800),
                                          const SizedBox(width: 6),
                                          Text(
                                            elem,
                                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (_testRawJson != null && _testElements == null && _testErrorMessage == null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Risposta Raw (Status $_testStatusCode):', style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(_testRawJson!, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Bottone Salvataggio API
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _saveApiSettings,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Salva Parametri API', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
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

  // Chiamata HTTP di TEST
  Future<void> _runApiTest() async {
    final baseUrl = _apiBaseUrlController.text.trim();
    final testEndpoint = _apiTestEndpointController.text.trim();
    final username = _apiUsernameController.text.trim();
    final password = _apiPasswordController.text;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci prima il Base URL per eseguire il test.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isTesting = true;
      _testErrorMessage = null;
      _testElements = null;
      _testRawJson = null;
      _testStatusCode = null;
    });

    try {
      // Costruzione dell'URL combinato
      String fullUrl = baseUrl;
      if (!fullUrl.endsWith('/') && !testEndpoint.startsWith('/') && testEndpoint.isNotEmpty) {
        fullUrl += '/$testEndpoint';
      } else if (fullUrl.endsWith('/') && testEndpoint.startsWith('/')) {
        fullUrl += testEndpoint.substring(1);
      } else {
        fullUrl += testEndpoint;
      }

      final uri = Uri.parse(fullUrl);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);

      final settings = ref.read(appSettingsProvider);
      if (settings.bypassSslVerification) {
        client.badCertificateCallback = (cert, host, port) => true;
      }

      final request = await client.getUrl(uri);

      // Autenticazione Basic con username e password
      if (username.isNotEmpty || password.isNotEmpty) {
        final credentials = base64Encode(utf8.encode('$username:$password'));
        request.headers.set(HttpHeaders.authorizationHeader, 'Basic $credentials');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final decoded = jsonDecode(responseBody);
          if (decoded is Map<String, dynamic> && decoded.containsKey('elements')) {
            final rawList = decoded['elements'];
            if (rawList is List) {
              setState(() {
                _testStatusCode = response.statusCode;
                _testElements = rawList.map((e) => e.toString()).toList();
                _testRawJson = responseBody;
              });
            } else {
              setState(() {
                _testStatusCode = response.statusCode;
                _testRawJson = responseBody;
              });
            }
          } else {
            setState(() {
              _testStatusCode = response.statusCode;
              _testRawJson = responseBody;
            });
          }
        } catch (_) {
          setState(() {
            _testStatusCode = response.statusCode;
            _testRawJson = responseBody;
          });
        }
      } else {
        setState(() {
          _testStatusCode = response.statusCode;
          _testErrorMessage = 'Codice risposta HTTP ${response.statusCode}\nCorpo: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        _testErrorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }
  }

  Future<void> _saveApiSettings() async {
    await ref.read(appSettingsProvider.notifier).updateApiSettings(
      apiBaseUrl: _apiBaseUrlController.text.trim(),
      apiUsername: _apiUsernameController.text.trim(),
      apiPassword: _apiPasswordController.text,
      apiTestEndpoint: _apiTestEndpointController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Parametri API SERVER salvati con successo nel database!'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
