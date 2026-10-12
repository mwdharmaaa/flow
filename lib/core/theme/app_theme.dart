import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF2F6FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardHover = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE5ECF6);
  static const Color subtle = Color(0xFF6E7F98);
  static const Color textPrimary = Color(0xFF0E1B31);

  static const Color primary = Color(0xFF1D61E0);
  static const Color primarySoft = Color(0xFFEBF2FF);
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color expenseRed = Color(0xFFEF4444);
  static const Color transfer = Color(0xFF1D61E0);
  static const Color warning = Color(0xFFF59E0B);

  // Layoutcraft Neutral Dark Palette (Zinc-950)
  static const Color darkBgBase = Color(0xFF09090B);
  static const Color darkBgSurface = Color(0xFF121215);
  static const Color darkBgElevated = Color(0xFF18181B);
  static const Color darkBorderSubtle = Color(0xFF27272A);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkAccentPrimary = Color(0xFF3B82F6);

  // Project0002 Sharp Corner Design Tokens
  // In dark mode: 2.0px razor-sharp Bauhaus/Linear edge matching project0002.
  // In light mode: smooth iOS/Material curve.
  static double radius(bool isDark, [double light = 16.0]) => isDark ? 2.0 : light;
  static BorderRadius borderRadius(bool isDark, [double light = 16.0]) =>
      BorderRadius.circular(isDark ? 2.0 : light);
  static BorderRadius verticalTop(bool isDark, [double light = 24.0]) =>
      BorderRadius.vertical(top: Radius.circular(isDark ? 2.0 : light));

  static ThemeData get lightTheme {
    return ThemeData(
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
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBgBase,
      primaryColor: darkAccentPrimary,
      colorScheme: const ColorScheme.dark(
        primary: darkAccentPrimary,
        surface: darkBgSurface,
        error: expense,
      ),
      cardTheme: CardTheme(
        color: darkBgElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          side: const BorderSide(color: darkBorderSubtle),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkBgElevated,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          side: const BorderSide(color: darkBorderSubtle),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkBgBase,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(2.0)),
        ),
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
        backgroundColor: darkBgElevated,
        selectedItemColor: darkAccentPrimary,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
