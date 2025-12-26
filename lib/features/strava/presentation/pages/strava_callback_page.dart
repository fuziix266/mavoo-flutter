import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Conditional import for web-only functionality
import 'strava_callback_web.dart' if (dart.library.io) 'strava_callback_mobile.dart';

class StravaCallbackPage extends StatefulWidget {
  const StravaCallbackPage({Key? key}) : super(key: key);

  @override
  State<StravaCallbackPage> createState() => _StravaCallbackPageState();
}

class _StravaCallbackPageState extends State<StravaCallbackPage> {
  @override
  void initState() {
    super.initState();
    handleCallback(context);
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
