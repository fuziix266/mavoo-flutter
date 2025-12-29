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
import '../../features/stats/presentation/pages/friends_stats_page.dart';
import '../../features/stats/presentation/pages/personal_stats_page.dart';

class AppLayout extends StatefulWidget {
  final Widget? child;
  
  const AppLayout({Key? key, this.child}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;

  void _onNavigationChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getMainContent() {
    // Check if the child is one of the routed pages (not Home or Events)
    // If child is HomePage or EventsPage from route, we still show based on index
    // Otherwise, show the child from ShellRoute
    
    if (widget.child != null) {
      // Check the current route to decide what to show
      final location = GoRouterState.of(context).matchedLocation;
      
      // For Home and Events routes, use internal navigation
      if (location == '/home') {
        return _getInternalPage();
      }
      
      // For other routes, show the ShellRoute child
      return widget.child!;
    }
    
    return _getInternalPage();
  }

  Widget _getInternalPage() {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const EventsPage();
      case 2:
        return const FriendsStatsPage();
      case 3:
        return const PersonalStatsPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = ResponsiveBreakpoints.isMobile(screenWidth);
    final isTablet = ResponsiveBreakpoints.isTablet(screenWidth);
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    
    // Determine if we're showing a special page (not Home/Events)
    final location = widget.child != null ? GoRouterState.of(context).matchedLocation : '/home';
    final isSpecialPage = location != '/home' && widget.child != null;
    
    // We want right sidebar to show on Home, Events, FriendsStats, PersonalStats (internal pages)
    // AND ALSO when we are in a "special page" but it fits the layout (user requested to fix "white screen").
    // However, usually special pages like Messages take full width.
    // The user said "se pierde el widget derecho" for Notifications/Messages.
    // Maybe they want the RightSidebar there too?
    // Let's enable it for Notifications, but maybe not Messages if it needs full width?
    // For now, I will modify it to show unless explicitly full screen.
    // Actually, simply removing !isSpecialPage might fix the "disappearing" issue if that's what they mean.
    // But NotificationsPage might look weird if constrained?
    // Let's keep it safe: Always show LeftSidebar (already done above).
    // Show RightSidebar if desktop, regardless of page, UNLESS it's a page that specifically hides it?
    // The user complaint "se pierde el widget derecho" implies they EXPECT it.

    final showRightSidebar = ResponsiveBreakpoints.showRightSidebar(screenWidth);
    final expandLeftSidebar = ResponsiveBreakpoints.expandLeftSidebar(screenWidth);
    final showBottomNav = ResponsiveBreakpoints.showBottomNav(screenWidth);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Top Navigation Bar (full width, always visible)
          if (!isMobile)
            TopNavigationBar(
              currentIndex: _currentIndex,
              onNavigationChanged: _onNavigationChanged,
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
                          currentIndex: _currentIndex,
                          onNavigationChanged: _onNavigationChanged,
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
                            child: location == '/reels'
                              ? Container(
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
                                      child: _getMainContent(),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
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
                                        child: _getMainContent(),
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
              currentIndex: _currentIndex,
              onNavigationChanged: _onNavigationChanged,
            )
          : null,
    );
  }
}
