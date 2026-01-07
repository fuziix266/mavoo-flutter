import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Ayuda y Soporte',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.borderLight,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HelpSectionHeader(title: 'Preguntas Frecuentes'),
            const SizedBox(height: 16),
            _HelpExpandableTile(
              title: '¿Cómo sincronizo mi cuenta?',
              content: 'Puedes sincronizar tu cuenta yendo a Configuración y seleccionando la opción de sincronización.',
            ),
            const SizedBox(height: 12),
            _HelpExpandableTile(
              title: '¿Cómo cambio mi foto de perfil?',
              content: 'Ve a tu perfil, toca el botón "Editar perfil" y selecciona una nueva foto de tu galería.',
            ),
            const SizedBox(height: 12),
            _HelpExpandableTile(
              title: '¿Cómo contacto al soporte?',
              content: 'Puedes enviarnos un correo electrónico a soporte@mavoo.cl o usar el formulario de contacto más abajo.',
            ),

            const SizedBox(height: 32),
            const _HelpSectionHeader(title: 'Contáctanos'),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: AppShadows.small,
              ),
              child: Column(
                children: [
                  const Text(
                    '¿No encuentras lo que buscas?',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nuestro equipo de soporte está listo para ayudarte con cualquier problema que tengas.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement contact form or email launch
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función de contacto próximamente')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Enviar mensaje',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'Versión 1.0.0',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpSectionHeader extends StatelessWidget {
  final String title;

  const _HelpSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.h3,
    );
  }
}

class _HelpExpandableTile extends StatefulWidget {
  final String title;
  final String content;

  const _HelpExpandableTile({
    required this.title,
    required this.content,
  });

  @override
  State<_HelpExpandableTile> createState() => _HelpExpandableTileState();
}

class _HelpExpandableTileState extends State<_HelpExpandableTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: const Border(), // Remove borders when expanded
        textColor: AppColors.primary,
        iconColor: AppColors.primary,
        collapsedTextColor: AppColors.textPrimary,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        children: [
          Text(
            widget.content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
