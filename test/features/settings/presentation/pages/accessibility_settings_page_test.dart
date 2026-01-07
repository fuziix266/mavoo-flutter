import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mavoo_flutter/features/settings/presentation/pages/accessibility_settings_page.dart';

void main() {
  testWidgets('AccessibilitySettingsPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AccessibilitySettingsPage()));

    // Verify AppBar
    expect(find.text('Accesibilidad'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Verify Section Headers
    expect(find.text('Pantalla y Texto'), findsOneWidget);
    expect(find.text('Movimiento'), findsOneWidget);
    expect(find.text('Lectura'), findsOneWidget);

    // Verify SwitchTiles
    expect(find.text('Texto Grande'), findsOneWidget);
    expect(find.text('Alto Contraste'), findsOneWidget);
    expect(find.text('Reducir Movimiento'), findsOneWidget);
    expect(find.text('Lector de Pantalla'), findsOneWidget);
  });

  testWidgets('Toggling switches updates state', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AccessibilitySettingsPage()));

    // Find the 'Texto Grande' switch
    final largeTextSwitchFinder = find.widgetWithText(SwitchListTile, 'Texto Grande');

    // Initially false
    SwitchListTile switchTile = tester.widget(largeTextSwitchFinder);
    expect(switchTile.value, false);

    // Tap to toggle
    await tester.tap(largeTextSwitchFinder);
    await tester.pump();

    // Verify it is now true
    switchTile = tester.widget(largeTextSwitchFinder);
    expect(switchTile.value, true);

    // Verify Slider appears when 'Texto Grande' is on
    expect(find.byType(Slider), findsOneWidget);
  });
}
