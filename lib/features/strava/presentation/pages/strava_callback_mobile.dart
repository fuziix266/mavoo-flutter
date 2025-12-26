import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void handleCallback(BuildContext context) {
  // On mobile, extract code from route and navigate back
  final uri = GoRouterState.of(context).uri;
  final code = uri.queryParameters['code'];
  
  if (code != null) {
    // Navigate back to devices page with the code
    // The DevicesPage will handle the OAuth exchange
    context.go('/devices?strava_code=$code');
  } else {
    // No code, just go back to devices
    context.go('/devices');
  }
}
