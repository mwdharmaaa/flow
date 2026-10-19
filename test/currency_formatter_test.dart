import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/formatters/thousands_separator_input_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formats IDR without decimals and dot separator', () {
      final formatted = CurrencyFormatter.format(1000, currency: 'IDR');
      expect(formatted, contains('1.000'));
      expect(formatted, contains('Rp'));
    });

    test('formats USD with 2 decimals and comma separator', () {
      final formatted = CurrencyFormatter.format(1000, currency: 'USD');
      expect(formatted, contains('1,000.00'));
      expect(formatted, contains('\$'));
    });

    test('formats amount input with thousand separators (IDR)', () {
      expect(CurrencyFormatter.formatAmountInput('1000', currency: 'IDR'), equals('1.000'));
      expect(CurrencyFormatter.formatAmountInput('50000', currency: 'IDR'), equals('50.000'));
      expect(CurrencyFormatter.formatAmountInput('1000000', currency: 'IDR'), equals('1.000.000'));
      expect(CurrencyFormatter.formatAmountInput('1000+500', currency: 'IDR'), equals('1.000 + 500'));
    });

    test('formats amount input with comma separator for USD', () {
      expect(CurrencyFormatter.formatAmountInput('1000', currency: 'USD'), equals('1,000'));
      expect(CurrencyFormatter.formatAmountInput('1000000', currency: 'USD'), equals('1,000,000'));
    });

    test('parses formatted amount back to double correctly', () {
      expect(CurrencyFormatter.parseAmount('1.000', currency: 'IDR'), equals(1000.0));
      expect(CurrencyFormatter.parseAmount('1.000.000', currency: 'IDR'), equals(1000000.0));
      expect(CurrencyFormatter.parseAmount('1,000.00', currency: 'USD'), equals(1000.0));
    });

    test('returns clean symbol for supported currencies', () {
      expect(CurrencyFormatter.getSymbol('IDR'), equals('Rp'));
      expect(CurrencyFormatter.getSymbol('USD'), equals('\$'));
      expect(CurrencyFormatter.getSymbol('EUR'), equals('€'));
      expect(CurrencyFormatter.getSymbol('JPY'), equals('¥'));
    });
  });

  group('ThousandsSeparatorInputFormatter', () {
    test('formats text edits dynamically', () {
      final formatter = ThousandsSeparatorInputFormatter(currency: 'IDR');
      const oldValue = TextEditingValue(text: '100');
      const newValue = TextEditingValue(text: '1000');
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, equals('1.000'));
    });
  });
}
