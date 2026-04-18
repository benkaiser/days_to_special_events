import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DaysToSpecialEventsApp());
}

class DaysToSpecialEventsApp extends StatelessWidget {
  const DaysToSpecialEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Penelope's Special Days",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
