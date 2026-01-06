# Responsive Layout Implementation

## 📐 Overview

Implementation of a fully responsive layout system for the Mavoo Flutter application, following Instagram/Facebook design patterns with unified page-level scrolling.

**Date**: December 24, 2025  
**Status**: ✅ Complete

---

## 🎯 Objectives

1. Implement responsive breakpoints for mobile, tablet, and desktop
2. Create unified page-level scroll (like Facebook)
3. Adjust sidebar widths and behavior across screen sizes
4. Increase font sizes for better readability
5. Ensure TopNavigationBar spans full screen width

---

## 📱 Responsive Breakpoints

### File: `lib/core/theme/responsive_breakpoints.dart`

```dart
class ResponsiveBreakpoints {
  // Breakpoints
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1280;

  // Layout dimensions
  static const double maxFeedWidth = 680;
  static const double leftSidebarWidth = 360;
  static const double leftSidebarCollapsed = 72;
  static const double rightSidebarWidth = 320;
}
```

**Breakpoint Logic**:

- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

---

## 🎨 Layout Structure

### Unified Scroll Architecture

```
Scaffold
└─ Column
   ├─ TopNavigationBar (full width, fixed)
   └─ Expanded
      └─ Align (topLeft) + ConstrainedBox (max 1600px)
         └─ Row
            ├─ LeftSidebar (360px, independent scroll)
            └─ Row
               ├─ CenterContent (Expanded, with scroll)
               └─ RightSidebar (320px, fixed)
```

### Key Changes

**File**: `lib/core/widgets/app_layout.dart`

1. **TopNavigationBar**: Moved outside `ConstrainedBox` to span full screen width
2. **Left Sidebar**: Wrapped in `SizedBox` with fixed width for independent scrolling
3. **Center Content**: Wrapped in `SingleChildScrollView` for unified page scroll
4. **Right Sidebar**: Fixed position, no scroll (has internal `Column`)

---

## 📏 Responsive Behavior

### Desktop (> 1024px)

- ✅ Left sidebar: **360px** (expanded, with labels)
- ✅ Right sidebar: **320px** (visible on Home & Events)
- ✅ Feed content: **680px max-width** (centered)
- ✅ Top navigation: **Full width**

### Tablet (768px - 1024px)

- ✅ Left sidebar: **72px** (collapsed, icons only)
- ✅ Right sidebar: **Hidden**
- ✅ Feed content: **680px max-width**
- ✅ Top navigation: **Full width**

### Mobile (< 768px)

- ✅ Left sidebar: **Hidden**
- ✅ Right sidebar: **Hidden**
- ✅ Feed content: **Full width**
- ✅ Top navigation: **Hidden**
- ✅ Bottom navigation: **Visible**

---

## 🔤 Typography Updates

### File: `lib/core/theme/app_theme.dart`

All font sizes increased by 1-2px for better readability:

| Style        | Before | After |
| ------------ | ------ | ----- |
| H1           | 32px   | 34px  |
| H2           | 24px   | 26px  |
| H3           | 20px   | 21px  |
| Body Large   | 16px   | 17px  |
| Body Medium  | 14px   | 15px  |
| Body Small   | 12px   | 13px  |
| Label Large  | 14px   | 15px  |
| Label Medium | 12px   | 13px  |
| Label Small  | 10px   | 11px  |

### Sidebar Navigation

- Navigation item font: **15px** (increased from 14px)

---

## 📦 Component Updates

### 1. LeftSidebar

**File**: `lib/core/widgets/left_sidebar.dart`

**Changes**:

- Added `expanded` parameter (bool)
- Width: `360px` (expanded) / `72px` (collapsed)
- Labels hidden when collapsed (icons only with tooltips)
- Mini-profile hidden when collapsed

```dart
LeftSidebar(
  currentIndex: _currentIndex,
  onNavigationChanged: _onNavigationChanged,
  expanded: expandLeftSidebar, // true on desktop, false on tablet
)
```

### 2. BottomNavigation

**File**: `lib/core/widgets/bottom_navigation.dart`

**New Component** for mobile devices:

- Height: **60px**
- Shows: Home, Events, Explore, Post, Profile
- Only visible on mobile (< 768px)

### 3. HomePage

**File**: `lib/features/home/presentation/pages/home_page.dart`

**Changes**:

- Removed `SingleChildScrollView` (scroll now at AppLayout level)
- Removed `RefreshIndicator`
- Uses `Column` with `ListView.builder` (shrinkWrap + NeverScrollableScrollPhysics)

### 4. EventsPage

**File**: `lib/features/events/presentation/pages/events_page.dart`

**Major Refactor**:

- Each page handles its own `SingleChildScrollView`
- Featured event displayed at top (largest participant count)
- Grid layout: **2 columns on desktop** (> 600px), **1 column on mobile**
- Uses `GridView.builder` with `shrinkWrap` and `NeverScrollableScrollPhysics`
- `_EventCard`: Uses `Expanded` for flexible height within grid
- Height controlled by `childAspectRatio: 0.85`

**Layout Structure**:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      Header,
      FeaturedEventCard (large),
      GridView.builder (2 columns),
    ],
  ),
)
```

**Grid Configuration**:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
      ),
    );
  },
)
```

---

## 🔄 Scroll Architecture (Final)

### Individual Page Scrolling

Each page manages its own scroll independently:

**AppLayout** (No scroll):

```dart
Row(
  children: [
    LeftSidebar (independent scroll),
    Expanded(
      child: _getCurrentPage(), // No scroll wrapper
    ),
    RightSidebar (no scroll),
  ],
)
```

**HomePage**:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      StoriesBar,
      ListView.builder(shrinkWrap, NeverScrollableScrollPhysics),
    ],
  ),
)
```

**EventsPage**:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      Header,
      FeaturedEvent,
      GridView.builder(shrinkWrap, NeverScrollableScrollPhysics),
    ],
  ),
)
```

**Benefits**:

- ✅ No nested scroll conflicts
- ✅ Each page controls its own scroll behavior
- ✅ No mouse tracker assertion errors
- ✅ Proper constraint propagation

---### 5. RightSidebar

**File**: `lib/core/widgets/right_sidebar.dart`

**Changes**:

- Changed `ListView` to `Column` (no scroll needed)
- Fixed width: **320px**
- Visible only on desktop for Home & Events pages

---

## 🐛 Issues Fixed

### 1. RenderFlex Overflow

**Problem**: Content overflowing when switching layouts  
**Solution**: Adjusted container heights and removed conflicting scroll views

### 2. Assertion Failed (box.dart:2251:12)

**Problem**: `Expanded` widget inside `Wrap` causing constraint errors  
**Solution**: Replaced `Expanded` with fixed heights in `_EventCard`

### 3. TopNavigationBar Not Full Width

**Problem**: Bar constrained by 1600px max-width  
**Solution**: Moved TopNavigationBar outside `ConstrainedBox`

### 4. Scroll Conflicts

**Problem**: Multiple `SingleChildScrollView` widgets conflicting  
**Solution**: Single scroll at AppLayout level, pages use `Column`

---

## 📊 Story Avatar Sizes

**File**: `lib/features/stories/presentation/widgets/stories_bar.dart`

Increased by 50% for better visibility:

- Avatar radius: **40px** (was 30px)
- Container width: **110px** (was 80px)
- Icon size: **40px** (was 30px)
- Container height: **120px** (was 110px)

---

## ✅ Testing Checklist

- [x] Desktop layout displays all sidebars correctly
- [x] Tablet layout collapses left sidebar to icons
- [x] Mobile layout shows bottom navigation
- [x] TopNavigationBar spans full screen width
- [x] Unified scroll works smoothly
- [x] Left sidebar has independent scroll
- [x] EventsPage displays without errors
- [x] HomePage displays without errors
- [x] Font sizes are readable
- [x] Story avatars are appropriately sized

---

## 🎯 Design Philosophy

Following **Facebook/Instagram** patterns:

1. **Single page scroll**: All content scrolls together (except left sidebar)
2. **Fixed navigation**: Top bar always visible (desktop/tablet)
3. **Responsive sidebars**: Adapt to screen size
4. **Content-first**: Maximum width ensures readability
5. **Mobile-friendly**: Bottom navigation for easy thumb access

---

## 📝 Notes

- Layout max-width: **1600px** (adjustable in `app_layout.dart`)
- Feed max-width: **680px** (adjustable in `responsive_breakpoints.dart`)
- All spacing aligned to left (space on right)
- Smooth transitions between breakpoints
- No horizontal scroll at any breakpoint
