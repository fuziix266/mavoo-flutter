import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../../../../core/theme/app_theme.dart';
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
  final int _userId = 1; // TODO: Get from auth

  @override
  void initState() {
    super.initState();
    _stravaRepository = StravaRepository(baseUrl: 'http://localhost:8000');
    _loadConnectionStatus();
    _setupOAuthListener();
  }

  void _setupOAuthListener() {
    // Listen for OAuth callback messages
    html.window.onMessage.listen((event) {
      if (event.data is String) {
        final data = event.data as String;
        if (data.startsWith('strava_code:')) {
          final code = data.substring('strava_code:'.length);
          _handleOAuthCallback(code);
        }
      }
    });
  }

  Future<void> _loadConnectionStatus() async {
    setState(() => _isLoading = true);

    final athleteData = await _stravaRepository.getAthlete(_userId);
    
    if (athleteData != null) {
      setState(() {
        _isConnected = athleteData['connected'] as bool;
        _athlete = athleteData['athlete'] as StravaAthlete?;
        _lastSync = athleteData['last_sync'] as String?;
      });

      if (_isConnected) {
        _loadActivities();
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadActivities() async {
    final activities = await _stravaRepository.getActivities(_userId, perPage: 10);
    setState(() {
      _activities = activities;
    });
  }

  Future<void> _connectStrava() async {
    final authUrl = await _stravaRepository.getAuthorizationUrl(_userId);
    
    if (authUrl != null) {
      // Open OAuth window
      html.window.open(authUrl, 'Strava Authorization', 'width=600,height=800');
    } else {
      _showError('Failed to get authorization URL');
    }
  }

  Future<void> _handleOAuthCallback(String code) async {
    setState(() => _isLoading = true);

    final athlete = await _stravaRepository.exchangeCode(code, _userId);
    
    if (athlete != null) {
      setState(() {
        _isConnected = true;
        _athlete = athlete;
      });
      _loadActivities();
      _showSuccess('Strava connected successfully!');
    } else {
      _showError('Failed to connect Strava');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _disconnect() async {
    final confirmed = await _showConfirmDialog(
      'Disconnect Strava',
      'Are you sure you want to disconnect your Strava account?',
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      final success = await _stravaRepository.disconnect(_userId);
      
      if (success) {
        setState(() {
          _isConnected = false;
          _athlete = null;
          _activities = [];
          _lastSync = null;
        });
        _showSuccess('Strava disconnected successfully');
      } else {
        _showError('Failed to disconnect Strava');
      }

      setState(() => _isLoading = false);
    }
  }

  Future<void> _syncActivities() async {
    setState(() => _isLoading = true);
    await _loadActivities();
    setState(() => _isLoading = false);
    _showSuccess('Activities synced successfully');
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

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
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
      children: [
        const Text(
          'Conecta tu cuenta de Strava para sincronizar automáticamente tus actividades deportivas.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
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
        ),
      ],
    );
  }

  Widget _buildConnectedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
