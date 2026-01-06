import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/utils/api_constants.dart';
import '../../data/models/strava_athlete_model.dart';
import '../../data/models/strava_activity_model.dart';
import '../../data/repositories/strava_repository.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late StravaRepository _stravaRepository;
  bool _isLoading = true;
  bool _isConnected = false;
  StravaAthlete? _athlete;
  List<StravaActivity> _activities = [];
  String? _lastSync;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _stravaRepository = StravaRepository(baseUrl: ApiConstants.baseUrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });
  }

  void _initializeUser() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      try {
        _userId = int.parse(authState.user.id);
        _loadConnectionStatus();
      } catch (e) {
        print('Error parsing user ID: $e');
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadConnectionStatus() async {
    if (_userId == null) return;
    setState(() => _isLoading = true);

    try {
      final athleteData = await _stravaRepository.getAthlete(_userId!);
      
      if (athleteData != null) {
        setState(() {
          _isConnected = athleteData['connected'] == true;
          if (_isConnected && athleteData['athlete'] != null) {
            _athlete = StravaAthlete.fromJson(athleteData['athlete']);
          }
          _lastSync = athleteData['last_sync'] as String?;
        });

        if (_isConnected) {
          _loadActivities();
        }
      }
    } catch (e) {
      print('Error loading connection status: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadActivities() async {
    if (_userId == null) return;
    try {
      final activities = await _stravaRepository.getActivities(_userId!, perPage: 10);
      setState(() {
        _activities = activities;
      });
    } catch (e) {
      print('Error loading activities: $e');
    }
  }

  Future<void> _connectStrava() async {
    if (_userId == null) {
      _showError('Usuario no identificado');
      return;
    }
    setState(() => _isLoading = true);
    
    try {
      final authUrl = await _stravaRepository.getAuthorizationUrl(_userId!);
      
      if (authUrl != null) {
        // Use FlutterWebAuth2 for in-app browser (Custom Tabs/Safari View Controller)
        final result = await FlutterWebAuth2.authenticate(
          url: authUrl,
          callbackUrlScheme: 'mavoo',
        );
        
        // Extract code from callback URL
        final uri = Uri.parse(result);
        final code = uri.queryParameters['code'];
        
        if (code != null) {
          // Exchange code for tokens
          final athlete = await _stravaRepository.exchangeCode(code, _userId!);
          
          if (athlete != null) {
            _showSuccess('¡Strava conectado exitosamente!');
            await _loadConnectionStatus();
          } else {
            _showError('Error al intercambiar código de autorización');
          }
        } else {
          _showError('No se recibió código de autorización');
        }
      } else {
        _showError('Error al obtener URL de autorización');
      }
    } catch (e) {
      if (e.toString().contains('CANCELED')) {
        _showInfo('Autorización cancelada');
      } else {
        _showError('Error: $e');
      }
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _disconnect() async {
    if (_userId == null) return;
    final confirmed = await _showConfirmDialog(
      'Desconectar Strava',
      '¿Estás seguro de que quieres desconectar tu cuenta de Strava?',
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      final success = await _stravaRepository.disconnect(_userId!);
      
      if (success) {
        setState(() {
          _isConnected = false;
          _athlete = null;
          _activities = [];
          _lastSync = null;
        });
        _showSuccess('Strava desconectado correctamente');
      } else {
        _showError('Error al desconectar Strava');
      }

      setState(() => _isLoading = false);
    }
  }

  Future<void> _syncActivities() async {
    setState(() => _isLoading = true);
    await _loadActivities();
    setState(() => _isLoading = false);
    _showSuccess('Actividades sincronizadas');
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Mis Dispositivos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Conecta tus dispositivos deportivos para sincronizar tus actividades',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Strava Card
          _buildStravaCard(),
        ],
      ),
    );
  }

  Widget _buildStravaCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Strava Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFC4C02),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_run, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Strava',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Sincroniza tus actividades deportivas',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (!_isConnected)
            _buildDisconnectedState()
          else
            _buildConnectedState(),
        ],
      ),
    );
  }

  Widget _buildDisconnectedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Conecta tu cuenta de Strava para sincronizar automáticamente tus actividades deportivas.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _connectStrava,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFC4C02),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Conectar con Strava',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _loadConnectionStatus,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Verificar conexión',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Connection Status
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conectado como ${_athlete?.fullName ?? "Usuario"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_lastSync != null)
                      Text(
                        'Última sincronización: $_lastSync',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Activities Section
        if (_activities.isNotEmpty) ...[
          const Text(
            'Actividades recientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._activities.map((activity) => _buildActivityItem(activity)),
          const SizedBox(height: 24),
        ],

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _disconnect,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Desconectar',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _syncActivities,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sincronizar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem(StravaActivity activity) {
    IconData icon;
    Color iconColor;

    switch (activity.type.toLowerCase()) {
      case 'run':
        icon = Icons.directions_run;
        iconColor = const Color(0xFFFC4C02);
        break;
      case 'ride':
        icon = Icons.directions_bike;
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'swim':
        icon = Icons.pool;
        iconColor = const Color(0xFF2196F3);
        break;
      default:
        icon = Icons.fitness_center;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activity.distanceKm} km • ${activity.durationFormatted}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
