import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'overlays/notifications_overlay.dart';
import 'overlays/chat_overlay.dart';

class TopNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;

  const TopNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onNavigationChanged,
  }) : super(key: key);

  void _showNotificationsOverlay(BuildContext context, GlobalKey buttonKey) {
    final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          Positioned(
            top: offset.dy + renderBox.size.height + 8,
            right: MediaQuery.of(context).size.width - (offset.dx + renderBox.size.width) - 10,
            child: const NotificationsOverlay(),
          ),
        ],
      ),
    );
  }

  void _showChatOverlay(BuildContext context) {
    // Show chat as a floating bottom-right window or similar
    // For now, let's use a Dialog positioned at bottom right
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 80,
            child: const ChatOverlay(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey notificationKey = GlobalKey();
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Left Section: Logo + Search
            Expanded(
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.sports_score,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Mavoo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Search Bar (clickable - navigates to search page)
                  GestureDetector(
                    onTap: () => context.go('/search'),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 180),
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Buscar...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Center Section: Navigation Icons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavIcon(
                  icon: Icons.home,
                  isActive: currentIndex == 0,
                  onTap: () => onNavigationChanged(0),
                ),
                const SizedBox(width: 8),
                _NavIcon(
                  icon: Icons.calendar_month,
                  isActive: currentIndex == 1,
                  onTap: () => onNavigationChanged(1),
                ),
                const SizedBox(width: 8),
                _NavIcon(
                  icon: Icons.groups,
                  isActive: currentIndex == 2,
                  onTap: () => onNavigationChanged(2),
                ),
                const SizedBox(width: 8),
                _NavIcon(
                  icon: Icons.leaderboard,
                  isActive: currentIndex == 3,
                  onTap: () => onNavigationChanged(3),
                ),
              ],
            ),
            
            // Right Section: Actions + Profile
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    key: notificationKey,
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => _showNotificationsOverlay(context, notificationKey),
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () => _showChatOverlay(context),
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 16),
                  // Profile Avatar with Custom Dropdown Menu
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String? profileImage;
                      if (state is AuthAuthenticated) {
                        profileImage = state.user.profileImage;
                      }

                      return PopupMenuButton<String>(
                        offset: const Offset(-200, 50),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: AppColors.surfaceLight,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderLight, width: 2),
                            color: AppColors.backgroundLight,
                          ),
                          child: ClipOval(
                            child: profileImage != null && profileImage.isNotEmpty
                                ? Image.network(
                                    profileImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                          ),
                        ),
                        itemBuilder: (BuildContext context) => [
                      // Settings
                      PopupMenuItem<String>(
                        value: 'settings',
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _UserMenuItem(
                          icon: Icons.settings,
                          label: 'Configuración y privacidad',
                        ),
                      ),
                      // Help
                      PopupMenuItem<String>(
                        value: 'help',
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _UserMenuItem(
                          icon: Icons.help_outline,
                          label: 'Ayuda y soporte técnico',
                        ),
                      ),
                      // Accessibility
                      PopupMenuItem<String>(
                        value: 'accessibility',
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _UserMenuItem(
                          icon: Icons.accessibility_new,
                          label: 'Accesibilidad',
                        ),
                      ),
                      // Language
                      PopupMenuItem<String>(
                        value: 'language',
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _UserMenuItem(
                          icon: Icons.language,
                          label: 'Idiomas',
                        ),
                      ),
                      const PopupMenuDivider(height: 1),
                      // Logout
                      PopupMenuItem<String>(
                        value: 'logout',
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _UserMenuItem(
                          icon: Icons.logout,
                          label: 'Cerrar sesión',
                        ),
                      ),
                    ],
                        onSelected: (String value) {
                          switch (value) {
                            case 'settings':
                              context.go('/settings');
                              break;
                            case 'help':
                              context.go('/help');
                              break;
                            case 'accessibility':
                              // TODO: Navigate to accessibility
                              break;
                            case 'language':
                              // TODO: Navigate to language settings
                              break;
                            case 'logout':
                              context.read<AuthBloc>().add(AuthLogoutRequested());
                              break;
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}

// Custom User Menu Item Widget
class _UserMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _UserMenuItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
