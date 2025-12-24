import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../theme/app_theme.dart';

class LeftSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final bool expanded;

  const LeftSidebar({
    Key? key,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.expanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expanded ? 256 : 72,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(
          right: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(expanded ? 24 : 8),
              children: [
                _NavItem(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => onNavigationChanged(0),
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.event,
                  label: 'Events',
                  isActive: currentIndex == 1,
                  onTap: () => onNavigationChanged(1),
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.explore,
                  label: 'Explore',
                  isActive: false,
                  onTap: () {},
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.add_box,
                  label: 'Add Post',
                  isActive: false,
                  onTap: () {},
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  isActive: false,
                  badge: '3',
                  onTap: () {},
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.message,
                  label: 'Messages',
                  isActive: false,
                  badge: '5',
                  onTap: () {},
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.video_library,
                  label: 'Reels',
                  isActive: false,
                  onTap: () {},
                  showLabel: expanded,
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  isActive: false,
                  onTap: () {},
                  showLabel: expanded,
                ),
              ],
            ),
          ),
          
          // Mini Profile (Bottom) - Using real user data
          if (expanded)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String displayName = 'User';
                String username = '@user';
                String? profileImage;
                
                if (state is AuthAuthenticated) {
                  displayName = state.user.fullName ?? state.user.username ?? 'User';
                  username = '@${state.user.username ?? 'user'}';
                  profileImage = state.user.profileImage;
                }
                
                return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.borderLight, width: 1),
                  ),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      // Avatar with online indicator
                      Stack(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: profileImage == null
                                  ? const LinearGradient(
                                      colors: [Color(0xFF0046FC), Color(0xFF00B2F6)],
                                    )
                                  : null,
                              border: Border.all(
                                color: AppColors.borderLight,
                                width: 2,
                              ),
                              image: profileImage != null
                                  ? DecorationImage(
                                      image: NetworkImage(profileImage),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: profileImage == null
                                ? Center(
                                    child: Text(
                                      displayName.isNotEmpty 
                                          ? displayName[0].toUpperCase() 
                                          : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.backgroundLight,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                        color: AppColors.textSecondary,
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final String? badge;
  final VoidCallback onTap;
  final bool showLabel;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.badge,
    required this.onTap,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: showLabel ? '' : label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? 16 : 8,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: showLabel ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                    size: 24,
                  ),
                  if (badge != null && !showLabel)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              if (showLabel)
                const SizedBox(width: 16),
              if (showLabel)
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              if (showLabel && badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
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
