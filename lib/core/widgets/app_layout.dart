import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../theme/responsive_breakpoints.dart';
import 'top_navigation_bar.dart';
import 'left_sidebar.dart';
import 'right_sidebar.dart';
import 'bottom_navigation.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/events/presentation/pages/events_page.dart';

class AppLayout extends StatefulWidget {
  final Widget? child;
  
  const AppLayout({Key? key, this.child}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/events')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/activity')) return 3; // Desktop
    if (location.startsWith('/devices')) return 4; // Desktop
    if (location.startsWith('/notifications')) return 5; // Desktop
    if (location.startsWith('/messages')) return 6; // Desktop
    if (location.startsWith('/reels')) return 7; // Desktop
    if (location.startsWith('/profile')) return 8; // Desktop last item / Mobile last item
    return 0;
  }

  void _onNavigationChanged(int index) {
    // Navigation is now handled by the widgets themselves calling context.go()
    // This callback might still be useful if we want to do something else
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = ResponsiveBreakpoints.isMobile(screenWidth);
    final isTablet = ResponsiveBreakpoints.isTablet(screenWidth);
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    
    final currentIndex = _calculateSelectedIndex(context);
    final location = GoRouterState.of(context).matchedLocation;
    
    // Only show right sidebar on Home
    final showRightSidebar = ResponsiveBreakpoints.showRightSidebar(screenWidth) && 
                             location == '/home';

    final expandLeftSidebar = ResponsiveBreakpoints.expandLeftSidebar(screenWidth);
    final showBottomNav = ResponsiveBreakpoints.showBottomNav(screenWidth);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Top Navigation Bar (full width, always visible)
          if (!isMobile)
            TopNavigationBar(
              currentIndex: currentIndex,
              onNavigationChanged: (index) {}, // Handled by buttons
            ),
          
          // Main content area with max-width constraint
          Expanded(
            child: Align(
              alignment: Alignment.topLeft, // Align to left, space on right
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Row(
                  children: [
                    // Left Sidebar (hidden on mobile) - with independent scroll
                    if (!isMobile)
                      SizedBox(
                        width: expandLeftSidebar ? 360 : 72,
                        child: LeftSidebar(
                          currentIndex: currentIndex,
                          onNavigationChanged: (index) {}, // Handled by buttons
                          expanded: expandLeftSidebar,
                        ),
                      ),
                    
                    // Center Content with scroll
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Center feed content with its own scroll
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: showRightSidebar
                                      ? Border(
                                          right: BorderSide(
                                            color: AppColors.borderLight,
                                            width: 1,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: isMobile 
                                          ? double.infinity 
                                          : ResponsiveBreakpoints.maxFeedWidth,
                                    ),
                                    child: widget.child,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Right Sidebar (only on desktop for home/events) - independent, no scroll for now
                          if (showRightSidebar)
                            const RightSidebar(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Navigation (only on mobile)
      bottomNavigationBar: showBottomNav
          ? BottomNavigation(
              currentIndex: currentIndex,
              onNavigationChanged: (index) {}, // Handled by buttons
            )
          : null,
    );
  }
}
