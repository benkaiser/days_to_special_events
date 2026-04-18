import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:days_to_special_events/main.dart';

Future<void> loadFonts() async {
  // Load Roboto
  final fontData = File('assets/fonts/Roboto.ttf').readAsBytesSync();
  final loader = FontLoader('Roboto')
    ..addFont(Future.value(ByteData.sublistView(Uint8List.fromList(fontData))));
  await loader.load();

  // Load Material Icons
  final iconFontPath = '${Directory.current.path}/build/flutter_assets/fonts/MaterialIcons-Regular.otf';
  final fallbackIconPath = 'assets/fonts/MaterialIcons-Regular.otf';
  File iconFile;
  if (File(iconFontPath).existsSync()) {
    iconFile = File(iconFontPath);
  } else if (File(fallbackIconPath).existsSync()) {
    iconFile = File(fallbackIconPath);
  } else {
    return; // Icons won't render but text will
  }
  final iconData = iconFile.readAsBytesSync();
  final iconLoader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(Uint8List.fromList(iconData))));
  await iconLoader.load();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('Home screen golden screenshot', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const DaysToSpecialEventsApp());

    // Pump frames to let AppState init (don't use pumpAndSettle — animations never settle)
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
