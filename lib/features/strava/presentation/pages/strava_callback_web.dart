import 'package:flutter/material.dart';
import 'dart:html' as html;

void handleCallback(BuildContext context) {
  // Get code from URL parameters
  final uri = Uri.parse(html.window.location.href);
  final code = uri.queryParameters['code'];
  
  if (code != null) {
    // Send code to parent window
    html.window.opener?.postMessage('strava_code:$code', '*');
    
    // Close this window after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      html.window.close();
    });
  }
}
