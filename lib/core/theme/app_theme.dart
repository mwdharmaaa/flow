import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0F17);
  static const Color surface = Color(0xFF131A26);
  static const Color card = Color(0xFF161F2E);
  static const Color cardHover = Color(0xFF1D283B);
  static const Color border = Color(0xFF202C3F);
  static const Color subtle = Color(0xFF8A99AD);

  static const Color primary = Color(0xFF00B5DD);
  static const Color primaryHover = Color(0xFF0098BA);
  static const Color income = Color(0xFF22C55E);
  static const Color expense = Color(0xFFEF4444);
  static const Color transfer = Color(0xFF00B5DD);
  static const Color warning = Color(0xFFF59E0B);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
        error: expense,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: subtle,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
