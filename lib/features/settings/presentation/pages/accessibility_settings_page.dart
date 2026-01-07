import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class AccessibilitySettingsPage extends StatefulWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  State<AccessibilitySettingsPage> createState() => _AccessibilitySettingsPageState();
}

class _AccessibilitySettingsPageState extends State<AccessibilitySettingsPage> {
  // Mock state for accessibility settings
  bool _highContrast = false;
  bool _reduceMotion = false;
  bool _largeText = false;
  bool _screenReader = false;
  double _textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accesibilidad'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Pantalla y Texto'),
              _buildSwitchTile(
                title: 'Texto Grande',
                subtitle: 'Aumentar el tamaño del texto en toda la aplicación',
                value: _largeText,
                onChanged: (value) {
                  setState(() {
                    _largeText = value;
                    if (value) {
                      _textScale = 1.2;
                    } else {
                      _textScale = 1.0;
                    }
                  });
                },
              ),
              if (_largeText)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Slider(
                          value: _textScale,
                          min: 1.0,
                          max: 2.0,
                          divisions: 5,
                          label: _textScale.toString(),
                          onChanged: (value) {
                            setState(() {
                              _textScale = value;
                            });
                          },
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Alto Contraste',
                subtitle: 'Aumentar el contraste de los colores para mejorar la legibilidad',
                value: _highContrast,
                onChanged: (value) {
                  setState(() {
                    _highContrast = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Movimiento'),
              _buildSwitchTile(
                title: 'Reducir Movimiento',
                subtitle: 'Limitar las animaciones y efectos de movimiento',
                value: _reduceMotion,
                onChanged: (value) {
                  setState(() {
                    _reduceMotion = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Lectura'),
              _buildSwitchTile(
                title: 'Lector de Pantalla',
                subtitle: 'Optimizar la interfaz para lectores de pantalla',
                value: _screenReader,
                onChanged: (value) {
                  setState(() {
                    _screenReader = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1);
  }
}
