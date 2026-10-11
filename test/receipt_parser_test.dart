import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/parsers/receipt_parser.dart';

void main() {
  group('ReceiptParser Tests', () {
    test('parses Indomaret receipt with line items and total', () {
      const sample = '''
INDOMARET POINT SUDIRMAN
2 x ROTI TAWAR 16.000
1 x SUSU ULTRA MILK 1L 21.500
SUBTOTAL 37.500
TOTAL 37.500
''';

      final result = ReceiptParser.parse(sample);
      expect(result.isValid, isTrue);
      expect(result.merchant, 'Indomaret');
      expect(result.total, 37500.0);
      expect(result.items.length, 2);
      expect(result.items.first.name, 'ROTI TAWAR');
      expect(result.items.first.quantity, 2);
      expect(result.items.first.price, 16000.0);
    });

    test('parses cafe receipt and correctly infers Food category', () {
      const sample = '''
KOPI KENANGAN MALL
1 x KOPI KENANGAN MANTAN 19.000
TOTAL 19.000
''';

      final result = ReceiptParser.parse(sample);
      expect(result.merchant, 'Kopi Kenangan');
      expect(result.suggestedCategory, 'Food');
      expect(result.total, 19000.0);
    });

    test('handles fallback when grand total line is missing', () {
      const sample = '''
WARUNG MAKAN
1 x AYAM GORENG 20.000
1 x ES TEH 5.000
''';

      final result = ReceiptParser.parse(sample);
      expect(result.isValid, isTrue);
      expect(result.total, 25000.0);
    });
  });
}
