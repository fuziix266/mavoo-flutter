import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;
  final VoidCallback onProfileClick;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    required this.onProfileClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            const Color(0xFF00B2F6).withOpacity(0.2),
            Colors.white.withOpacity(0.95),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: const Color(0xFF0046FC).withOpacity(0.2),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0046FC).withOpacity(0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0046FC), Color(0xFF00B2F6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B2F6).withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mavoo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0046FC),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  route: '/home',
                ),
                _buildNavItem(
                  icon: Icons.search,
                  label: 'Search',
                  route: '/search',
                ),
                _buildNavItem(
                  icon: Icons.explore,
                  label: 'Explore',
                  route: '/explore',
                ),
                _buildNavItem(
                  icon: Icons.add_box,
                  label: 'Add Post',
                  route: '/add-post',
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  route: '/notifications',
                  badge: 3,
                ),
                _buildNavItem(
                  icon: Icons.message,
                  label: 'Messages',
                  route: '/messages',
                  badge: 5,
                ),
                _buildNavItem(
                  icon: Icons.video_library,
                  label: 'Reels',
                  route: '/reels',
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  route: '/settings',
                ),
              ],
            ),
          ),

          // User Profile
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String displayName = 'User';
              String username = '@user';
              
              if (state is AuthAuthenticated) {
                displayName = state.user.fullName ?? state.user.username ?? 'User';
                username = '@${state.user.username ?? 'user'}';
              }
              
              return InkWell(
                onTap: onProfileClick,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0046FC).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: (state is AuthAuthenticated && state.user.profileImage != null)
                              ? null
                              : const LinearGradient(
                                  colors: [Color(0xFF0046FC), Color(0xFF00B2F6)],
                                ),
                          border: Border.all(
                            color: const Color(0xFF0046FC).withOpacity(0.3),
                            width: 2,
                          ),
                          image: (state is AuthAuthenticated && state.user.profileImage != null)
                              ? DecorationImage(
                                  image: NetworkImage(state.user.profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (state is AuthAuthenticated && state.user.profileImage != null)
                            ? null
                            : Center(
                                child: Text(
                                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String route,
    int? badge,
  }) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onNavigate(route),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [Color(0xFF0046FC), Color(0xFF00B2F6)],
                    )
                  : null,
              color: isActive ? null : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0046FC).withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : const Color(0xFF0046FC).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: isActive ? Colors.white : const Color(0xFF0046FC),
                      ),
                      if (badge != null)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.pink],
                              ),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              badge.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : Colors.black,
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
