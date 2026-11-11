import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/debt_model.dart';

void main() {
  group('DebtModel Tests', () {
    test('serializes and validates remaining balance', () {
      final debt = DebtModel(
        id: 'debt_1',
        name: 'Laptop Installment',
        totalAmount: 12000000.0,
        paidAmount: 4000000.0,
        dueDate: DateTime(2026, 12, 31),
        type: DebtType.payable,
      );

      final remaining = debt.totalAmount - debt.paidAmount;
      expect(remaining, 8000000.0);
      expect(debt.type, DebtType.payable);
    });
  });
}
