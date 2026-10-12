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

  // Liquid Glass Neutral Dark Palette & Luminous Specular Tokens
  static const Color darkBgBase = Color(0xFF09090B);
  static const Color darkBgSurface = Color(0xCC121217);
  static const Color darkBgElevated = Color(0xD9181822);
  static const Color darkBorderSubtle = Color(0x2EFFFFFF);
  static const Color darkBorderHighlight = Color(0x40FFFFFF);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkAccentPrimary = Color(0xFF3B82F6);

  // Liquid Glass Smooth Curved Design Tokens
  static double radius(bool isDark, [double light = 16.0]) => light;
  static BorderRadius borderRadius(bool isDark, [double light = 16.0]) =>
      BorderRadius.circular(light);
  static BorderRadius verticalTop(bool isDark, [double light = 24.0]) =>
      BorderRadius.vertical(top: Radius.circular(light));

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
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: darkBorderSubtle),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkBgElevated,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(color: darkBorderSubtle),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkBgBase,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
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

  static BoxDecoration liquidGlassDecoration({
    required bool isDark,
    double radius = 16.0,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? color,
    double borderWidth = 1.0,
    bool elevated = false,
  }) {
    final r = borderRadius ?? BorderRadius.circular(radius);
    return BoxDecoration(
      borderRadius: r,
      color: color ??
          (isDark
              ? (elevated ? darkBgElevated : darkBgSurface)
              : (elevated ? const Color(0xF2FFFFFF) : const Color(0xE6FFFFFF))),
      border: Border.all(
        color: borderColor ?? (isDark ? darkBorderSubtle : border.withValues(alpha: 0.8)),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.04),
          blurRadius: elevated ? 20 : 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
