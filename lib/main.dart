import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SiteShortcutsApp());
}

class SiteShortcutsApp extends StatelessWidget {
  const SiteShortcutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Site Shortcuts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B5FFF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 22, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 20, color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(64, 64),
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        iconTheme: const IconThemeData(size: 28),
      ),
      // Deliberately NOT capping textScaler - this lets the phone's own
      // "large text" / font size accessibility setting scale everything.
      home: const HomeScreen(),
    );
  }
}
