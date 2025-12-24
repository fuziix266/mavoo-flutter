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
      child: MaterialApp.router(
        title: 'Mavoo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}



final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return const AppLayout();
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const PlaceholderPage(title: 'Search'),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const PlaceholderPage(title: 'Explore'),
        ),
        GoRoute(
          path: '/add-post',
          builder: (context, state) => const PlaceholderPage(title: 'Add Post'),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const PlaceholderPage(title: 'Notifications'),
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => const PlaceholderPage(title: 'Messages'),
        ),
        GoRoute(
          path: '/reels',
          builder: (context, state) => const PlaceholderPage(title: 'Reels'),
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
          builder: (context, state) => const PlaceholderPage(title: 'Profile'),
        ),
      ],
    ),
  ],
);
