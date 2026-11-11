import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flow/core/formatters/thousands_separator_input_formatter.dart';

void main() {
  group('ThousandsSeparatorInputFormatter Tests', () {
    test('formats text editing value with thousand periods', () {
      final formatter = ThousandsSeparatorInputFormatter();
      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(
        text: '1000000',
        selection: TextSelection.collapsed(offset: 7),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1.000.000');
    });
  });
}
