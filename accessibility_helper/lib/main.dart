import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AccessibilityApp());
}

class AccessibilityApp extends StatelessWidget {
  const AccessibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Accessibility Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
