import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

void main() {
  group('AppTheme Tests', () {
    test('verifies dark theme seed and scaffold brightness', () {
      final darkTheme = AppTheme.darkTheme;
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.scaffoldBackgroundColor, isNotNull);
    });
  });
}
