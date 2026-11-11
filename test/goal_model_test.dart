import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/goal_model.dart';

void main() {
  group('GoalModel Tests', () {
    test('calculates target progress percentage', () {
      final goal = GoalModel(
        id: 'goal_1',
        title: 'Emergency Fund',
        targetAmount: 50000000.0,
        currentAmount: 25000000.0,
        targetDate: DateTime(2027, 1, 1),
        colorValue: 0xFF2E7D32,
      );

      final progress = goal.currentAmount / goal.targetAmount;
      expect(progress, 0.5);
    });
  });
}
