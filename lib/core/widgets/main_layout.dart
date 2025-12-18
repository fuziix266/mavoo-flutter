import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FB),
        body: Row(
          children: [
            // Persistent Sidebar
            AppSidebar(
              currentRoute: currentLocation,
              onNavigate: (route) {
                context.go(route);
              },
              onProfileClick: () {
                context.go('/profile');
              },
            ),
            // Dynamic Content
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
