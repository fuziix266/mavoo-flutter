# Authentication & Authorization System

## 🔐 Security Implementation

**Date**: December 24, 2025  
**Status**: ✅ Implemented

---

## Overview

Mavoo implements a robust authentication system that ensures **only authenticated users** can access internal content. The system uses `GoRouter` with authentication guards and `flutter_bloc` for state management.

---

## Authentication Flow

### 1. Login Process

```
User → LoginPage → AuthBloc.add(AuthLoginRequested)
  → API Call → Token Storage → AuthAuthenticated State
  → Auto-redirect to /home
```

### 2. Session Check

```
App Start → AuthBloc.add(AuthCheckRequested)
  → Check Stored Token → Validate with API
  → AuthAuthenticated OR AuthUnauthenticated
```

### 3. Logout Process

```
User Clicks "Cerrar sesión" → AuthBloc.add(AuthLogoutRequested)
  → Clear Token → AuthUnauthenticated State
  → Auto-redirect to / (Login)
```

---

## Route Protection

### Implementation: `main.dart`

**GoRouter Redirect Guard**:

```dart
redirect: (BuildContext context, GoRouterState state) {
  final authState = context.read<AuthBloc>().state;
  final isAuthenticated = authState is AuthAuthenticated;
  final isGoingToLogin = state.matchedLocation == '/';

  // Block unauthenticated users from protected routes
  if (!isAuthenticated && !isGoingToLogin) {
    return '/';  // Redirect to login
  }

  // Redirect authenticated users away from login
  if (isAuthenticated && isGoingToLogin) {
    return '/home';
  }

  return null;  // Allow navigation
}
```

**Auto-Refresh on Auth Changes**:

```dart
refreshListenable: GoRouterRefreshStream(context.read<AuthBloc>().stream)
```

---

## Protected Routes

All routes except `/` (login) require authentication:

| Route            | Description   | Auth Required |
| ---------------- | ------------- | ------------- |
| `/`              | Login Page    | ❌ Public     |
| `/home`          | Home Feed     | ✅ Protected  |
| `/events/all`    | Events List   | ✅ Protected  |
| `/events/:id`    | Event Detail  | ✅ Protected  |
| `/profile`       | User Profile  | ✅ Protected  |
| `/messages`      | Messages      | ✅ Protected  |
| `/notifications` | Notifications | ✅ Protected  |
| `/settings`      | Settings      | ✅ Protected  |

---

## Security Guarantees

### ✅ **Enforced Rules**:

1. **No unauthenticated access**: Users without valid session cannot view any internal content
2. **Automatic redirects**: Logout immediately redirects to login page
3. **Real-time enforcement**: Auth state changes trigger immediate route re-evaluation
4. **Token validation**: Every app start validates stored token with backend

### 🔒 **Protection Mechanisms**:

- **Route Guards**: `GoRouter.redirect` checks auth state on every navigation
- **State Listening**: `GoRouterRefreshStream` reacts to `AuthBloc` state changes
- **Token Storage**: Secure token persistence using `flutter_secure_storage`
- **API Validation**: Backend validates token on every request

---

## Future Feature: Public Post Sharing

### 📋 **Planned Implementation**

**Goal**: Allow users to share individual posts publicly via link, viewable without login.

**Route Structure**:

```dart
GoRoute(
  path: '/p/:postId',  // Public post route
  builder: (context, state) {
    final postId = state.pathParameters['postId']!;
    return PublicPostPage(postId: postId);
  },
)
```

**Redirect Logic Update**:

```dart
redirect: (BuildContext context, GoRouterState state) {
  final authState = context.read<AuthBloc>().state;
  final isAuthenticated = authState is AuthAuthenticated;
  final isPublicRoute = state.matchedLocation.startsWith('/p/');
  final isGoingToLogin = state.matchedLocation == '/';

  // Allow public post viewing without auth
  if (isPublicRoute) {
    return null;  // Allow access
  }

  // Existing auth checks...
}
```

**Backend Endpoint**:

```
GET /content/post/:id/public
- No authentication required
- Returns post data with limited user info
- Includes share metadata for social media
```

**UI Considerations**:

- Minimal header (no navigation)
- "Sign up to see more" CTA
- Share buttons (WhatsApp, Facebook, Twitter)
- Open Graph meta tags for previews

---

## Testing Checklist

- [x] Unauthenticated users redirected to login
- [x] Logout redirects to login page
- [x] Login redirects to home
- [x] Direct URL access blocked for protected routes
- [x] Auth state changes trigger navigation
- [ ] Public post sharing (future feature)

---

## Code Locations

| Component     | File                                                   |
| ------------- | ------------------------------------------------------ |
| Router Config | `lib/main.dart`                                        |
| Auth Guards   | `lib/main.dart` (\_createRouter)                       |
| Auth Bloc     | `lib/features/auth/presentation/bloc/auth_bloc.dart`   |
| Login Page    | `lib/features/auth/presentation/pages/login_page.dart` |
| Logout Button | `lib/core/widgets/top_navigation_bar.dart`             |

---

## Notes

- **Security First**: No content accessible without authentication
- **User Experience**: Seamless redirects on auth state changes
- **Extensible**: Foundation ready for public sharing feature
- **Reactive**: Real-time response to authentication events
