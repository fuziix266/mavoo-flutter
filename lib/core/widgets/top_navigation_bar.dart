import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TopNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;

  const TopNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onNavigationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  // Search Bar
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.search,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search events, people, teams...',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 14),
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
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {},
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 16),
                  // Profile Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight, width: 2),
                      color: AppColors.backgroundLight,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
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
