class ResponsiveBreakpoints {
  // Screen size breakpoints
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1280;
  
  // Layout dimensions
  static const double maxFeedWidth = 600;
  static const double leftSidebarWidth = 240;
  static const double leftSidebarCollapsed = 72;
  static const double rightSidebarWidth = 320;
  
  // Helper methods
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
  
  static bool showRightSidebar(double width) => width >= desktop;
  static bool expandLeftSidebar(double width) => width >= desktop;
  static bool showBottomNav(double width) => width < mobile;
}
