import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:days_to_special_events/main.dart';

void main() {
  testWidgets('Home screen golden screenshot', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const DaysToSpecialEventsApp());

    // Pump a few frames to let AppState init (don't use pumpAndSettle — animations never settle)
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_screen.png'),
    );
  });

  testWidgets('Top of year golden screenshot', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const DaysToSpecialEventsApp());

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Fling to the very top
    final scrollable = find.byType(Scrollable).first;
    await tester.fling(scrollable, const Offset(0, 10000), 5000);
    for (int i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/top_of_year.png'),
    );
  });
}
