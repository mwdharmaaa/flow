import 'package:flutter_test/flutter_test.dart';
import 'package:flow/features/transactions/models/category_item_data.dart';

void main() {
  group('CategoryItemData Tests', () {
    test('contains standard default expense presets', () {
      final presets = CategoryItemData.defaultCategories;
      expect(presets, isNotEmpty);
      expect(presets.any((c) => c.name == 'Food'), isTrue);
      expect(presets.any((c) => c.name == 'Transport'), isTrue);
    });
  });
}
