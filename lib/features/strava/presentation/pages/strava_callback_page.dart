import 'package:flutter/material.dart';
import 'dart:html' as html;

class StravaCallbackPage extends StatefulWidget {
  const StravaCallbackPage({Key? key}) : super(key: key);

  @override
  State<StravaCallbackPage> createState() => _StravaCallbackPageState();
}

class _StravaCallbackPageState extends State<StravaCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  void _handleCallback() {
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Conectando con Strava...'),
          ],
        ),
      ),
    );
  }
}
