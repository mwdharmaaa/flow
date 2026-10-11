import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/models/transaction_model.dart';

void main() {
  group('NlpTransactionParser Tests', () {
    test('parses spoken Indonesian words correctly', () {
      final res1 = NlpTransactionParser.parse('beli kopi dua puluh lima ribu');
      expect(res1.isValid, isTrue);
      expect(res1.amount, 25000.0);
      expect(res1.category, 'Food');

      final res2 = NlpTransactionParser.parse('isi bensin lima puluh ribu');
      expect(res2.isValid, isTrue);
      expect(res2.amount, 50000.0);
      expect(res2.category, 'Transport');

      final res3 = NlpTransactionParser.parse('gaji kantor lima juta');
      expect(res3.isValid, isTrue);
      expect(res3.amount, 5000000.0);
      expect(res3.category, 'Salary');
      expect(res3.type, TransactionType.income);
    });

    test('parses shorthand expressions', () {
      final res = NlpTransactionParser.parse('makan siang 35k');
      expect(res.isValid, isTrue);
      expect(res.amount, 35000.0);
      expect(res.category, 'Food');
    });
  });
}
