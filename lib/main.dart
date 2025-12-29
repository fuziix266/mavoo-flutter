import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'core/widgets/app_layout.dart';
import 'core/widgets/placeholder_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/events/presentation/pages/all_events_page.dart';
import 'features/events/presentation/pages/event_detail_page.dart';
import 'features/events/data/models/event_model.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'features/strava/presentation/pages/devices_page.dart';
import 'features/strava/presentation/pages/strava_callback_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/notifications/presentation/pages/notifications_page.dart';
import 'features/messages/presentation/pages/messages_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Mavoo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: _createRouter(context),
          );
        },
      ),
    );
  }
}

GoRouter _createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/';
      final isStravaCallback = state.matchedLocation.startsWith('/strava/callback');
      
      print('Redirect check: ${state.matchedLocation}, auth: $isAuthenticated'); // Debug
      
      // Allow Strava callback without redirect
      if (isStravaCallback) {
        print('Allowing Strava callback');
        return null;
      }
      
      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuthenticated && !isGoingToLogin) {
        print('Not authenticated, redirecting to login');
        return '/';
      }
      
      // If authenticated and on login page, redirect to home
      if (isAuthenticated && isGoingToLogin) {
        print('Authenticated on login, redirecting to home');
        return '/home';
      }
      
      // No redirect needed
      print('No redirect needed');
      return null;
    },
    refreshListenable: GoRouterRefreshStream(context.read<AuthBloc>().stream),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/strava/callback',
        builder: (context, state) => const StravaCallbackPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/explore',
            builder: (context, state) => const DevicesPage(),
          ),
          GoRoute(
            path: '/add-post',
            builder: (context, state) => const PlaceholderPage(title: 'Add Post'),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/messages',
            builder: (context, state) => const MessagesPage(),
          ),
          GoRoute(
            path: '/reels',
            builder: (context, state) => const PlaceholderPage(title: 'Reels'),
          ),
          GoRoute(
            path: '/devices',
            builder: (context, state) => const DevicesPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/events/all',
            builder: (context, state) {
              final events = state.extra as List<dynamic>;
              return AllEventsPage(events: events.cast());
            },
          ),
          GoRoute(
            path: '/events/:id',
            builder: (context, state) {
              final event = state.extra as Event;
              return EventDetailPage(event: event);
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}

// Helper class to make GoRouter refresh when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
