import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/widgets/placeholder_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors from original design
    const kPrimaryGradient = LinearGradient(
      colors: [Color(0xFF6C47B7), Color(0xFF341F60)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    const kRedColor = Color(0xFFFF2525);
    const kDividerColor = Color(0xFFE0E0E0); // Approximation of bg-gradient-bg

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Sidebar (Menu)
          SizedBox(
            width: 400, // lg:w-[400px]
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header Section
                        SizedBox(
                          height: 350, // Combined height of background + profile overlap
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // Background Images
                              SizedBox(
                                height: 250,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Placeholder for SettingsProfileBackground.png
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xFFE0F7FA), Color(0xFFE1F5FE)],
                                        ),
                                      ),
                                    ),
                                    // Placeholder for SettingsShadowProfile.png overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          
                              // Profile Info (Overlapping)
                              Positioned(
                                top: 180, // Adjust to overlap correctly
                                child: Column(
                                  children: [
                                    // Profile Image
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        String? profileImage;
                                        
                                        if (state is AuthAuthenticated) {
                                          profileImage = state.user.profileImage;
                                        }
                                        
                                        return Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: CircleAvatar(
                                            radius: 56,
                                            backgroundColor: const Color(0xFFF0F0F0),
                                            backgroundImage: profileImage != null 
                                                ? NetworkImage(profileImage) 
                                                : null,
                                            child: profileImage == null 
                                                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Username
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        String displayName = 'User';
                                        
                                        if (state is AuthAuthenticated) {
                                          displayName = state.user.fullName ?? state.user.username ?? 'User';
                                        }
                                        
                                        return Text(
                                          displayName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    // Online Status
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Online',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF252525),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Menu Options
                        const SizedBox(height: 20),
                        _buildDivider(),
                        _buildMenuOption(
                          icon: Icons.bookmark_border,
                          title: 'Saved Bookmark',
                          trailingText: '0', 
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuOption(
                          icon: Icons.block,
                          title: 'Block Contacts',
                          trailingText: '0',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuOption(
                          icon : Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuOption(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuOption(
                          icon: Icons.language,
                          title: 'Language',
                          onTap: () {},
                        ),
                        _buildDivider(opacity: 0.1),
                        _buildMenuOption(
                          icon: Icons.logout,
                          title: 'Logout',
                          textColor: kRedColor,
                          iconColor: kRedColor,
                          onTap: () => _showLogoutDialog(context),
                        ),
                        _buildDivider(opacity: 0.1),

                        // Delete Account Button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Delete Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

          // Right Content Area (Placeholder for now, implementation depends on selection)
          Expanded(
            child: Container(
              color: const Color(0xFFFAFAFA),
              child: const Center(
                child: Text('Select an option from the menu'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    String? trailingText,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (title != 'Logout') // Logout doesn't have an arrow in the original design screenshot implications, but standard list items do. Keeping it consistent.
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider({double opacity = 1.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: const Color(0xFFE0E0E0).withOpacity(opacity),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
