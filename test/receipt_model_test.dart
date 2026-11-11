import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/receipt_model.dart';

void main() {
  group('ReceiptModel Tests', () {
    test('serializes receipt total and item count', () {
      final item = ReceiptItem(name: 'Kopi Susu', price: 18000.0, quantity: 2);
      final receipt = ReceiptData(
        merchantName: 'Kopi Kenangan',
        date: DateTime(2026, 11, 11),
        totalAmount: 36000.0,
        items: [item],
      );

      expect(receipt.merchantName, 'Kopi Kenangan');
      expect(receipt.totalAmount, 36000.0);
      expect(receipt.items.length, 1);
      expect(receipt.items.first.total, 36000.0);
    });
  });
}
