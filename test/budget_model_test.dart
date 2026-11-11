import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/budget_model.dart';

void main() {
  group('BudgetModel Tests', () {
    test('serializes and deserializes from JSON', () {
      final budget = BudgetModel(
        id: 'bg_1',
        category: 'Food',
        monthlyLimit: 2000000.0,
        spent: 500000.0,
        colorValue: 0xFFF57C00,
      );

      final json = budget.toJson();
      final restored = BudgetModel.fromJson(json);

      expect(restored.id, 'bg_1');
      expect(restored.category, 'Food');
      expect(restored.monthlyLimit, 2000000.0);
      expect(restored.spent, 500000.0);
    });

    test('calculates budget utilization properly', () {
      final budget = BudgetModel(
        id: 'bg_2',
        category: 'Entertainment',
        monthlyLimit: 1000000.0,
        spent: 800000.0,
        colorValue: 0xFF7B1FA2,
      );

      final double remaining = budget.monthlyLimit - budget.spent;
      final double ratio = budget.spent / budget.monthlyLimit;

      expect(remaining, 200000.0);
      expect(ratio, 0.8);
    });
  });
}
