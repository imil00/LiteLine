import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 
import 'package:liteline/screens/login_page.dart'; 
import 'package:liteline/screens/home_page.dart';

void main() {
  runApp(const LitelineApp()); 
}

class LitelineApp extends StatelessWidget {
  const LitelineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0a0a0a),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: 'Inter')),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E), 
          foregroundColor: Colors.white, 
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.amber, 
        ),
      ),
      home: const LoginPage(), 
    );
  }
}