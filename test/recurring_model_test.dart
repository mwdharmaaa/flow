import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/recurring_model.dart';

void main() {
  group('RecurringModel Tests', () {
    test('verifies recurring interval and active status', () {
      final recurring = RecurringModel(
        id: 'rec_1',
        title: 'Spotify Premium',
        amount: 54990.0,
        category: 'Subscription',
        interval: RecurringInterval.monthly,
        startDate: DateTime(2026, 1, 1),
        isActive: true,
      );

      expect(recurring.isActive, isTrue);
      expect(recurring.interval, RecurringInterval.monthly);
      expect(recurring.amount, 54990.0);
    });
  });
}
