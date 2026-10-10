import 'package:flutter/material.dart';

class AppTheme {
  static bool isDark = false;

  // Moni Light Palette
  static const Color background = Color(0xFFF2F6FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardHover = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE5ECF6);
  static const Color subtle = Color(0xFF6E7F98);
  static const Color textPrimary = Color(0xFF0E1B31);
  static const Color primary = Color(0xFF1D61E0);
  static const Color primarySoft = Color(0xFFEBF2FF);

  // Layoutcraft Dark Palette (zinc-950 base)
  static const Color darkBgBase = Color(0xFF09090B);
  static const Color darkBgSurface = Color(0xFF121215);
  static const Color darkBgElevated = Color(0xFF18181B);
  static const Color darkBgOverlay = Color(0xFF222226);
  static const Color darkBorderSubtle = Color(0xFF27272A);
  static const Color darkBorderMuted = Color(0xFF3F3F46);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextMuted = Color(0xFF71717A);
  static const Color darkAccentPrimary = Color(0xFF3B82F6);
  static const Color darkAccentSubtle = Color(0x1F3B82F6);

  // Status Colors
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color transfer = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF59E0B);

  // Dynamic getters based on active mode
  static Color get bg => isDark ? darkBgBase : background;
  static Color get surfaceColor => isDark ? darkBgSurface : surface;
  static Color get cardColor => isDark ? darkBgElevated : card;
  static Color get cardHoverColor => isDark ? darkBgOverlay : cardHover;
  static Color get borderColor => isDark ? darkBorderSubtle : border;
  static Color get subtleColor => isDark ? darkTextSecondary : subtle;
  static Color get text => isDark ? darkTextPrimary : textPrimary;
  static Color get primaryColor => isDark ? darkAccentPrimary : primary;
  static Color get primarySoftColor => isDark ? darkAccentSubtle : primarySoft;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
        error: expense,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBgBase,
      primaryColor: darkAccentPrimary,
      colorScheme: const ColorScheme.dark(
        primary: darkAccentPrimary,
        surface: darkBgSurface,
        error: expense,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBgBase,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBgSurface,
        selectedItemColor: darkAccentPrimary,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
