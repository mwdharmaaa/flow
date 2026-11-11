import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/account_model.dart';

void main() {
  group('AccountModel Tests', () {
    test('serializes and deserializes accurately from JSON', () {
      final account = AccountModel(
        id: 'acc_1',
        name: 'BCA Main',
        type: 'Bank',
        balance: 1500000.0,
        colorValue: 0xFF1976D2,
        isExcludedFromTotal: false,
      );

      final json = account.toJson();
      final restored = AccountModel.fromJson(json);

      expect(restored.id, 'acc_1');
      expect(restored.name, 'BCA Main');
      expect(restored.type, 'Bank');
      expect(restored.balance, 1500000.0);
      expect(restored.colorValue, 0xFF1976D2);
      expect(restored.isExcludedFromTotal, isFalse);
    });

    test('copyWith properly preserves unmutated properties', () {
      final account = AccountModel(
        id: 'acc_2',
        name: 'Cash Wallet',
        type: 'Cash',
        balance: 50000.0,
        colorValue: 0xFF388E3C,
      );

      final updated = account.copyWith(balance: 75000.0);
      expect(updated.id, 'acc_2');
      expect(updated.name, 'Cash Wallet');
      expect(updated.balance, 75000.0);
      expect(updated.colorValue, 0xFF388E3C);
    });
  });
}
