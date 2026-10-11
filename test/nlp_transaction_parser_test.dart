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

    test('parses multiple spoken transactions with conjunctions', () {
      final items = NlpTransactionParser.parseAll('matcha 28k dan esteh 3k');
      expect(items.length, 2);
      expect(items[0].title, 'Matcha');
      expect(items[0].amount, 28000.0);
      expect(items[0].category, 'Food');
      expect(items[1].title, 'Esteh');
      expect(items[1].amount, 3000.0);
      expect(items[1].category, 'Food');
    });

    test('parses multiple transactions with commas and mixed categories', () {
      final items = NlpTransactionParser.parseAll('kopi 20k, roti 15k, sama parkir 2k');
      expect(items.length, 3);
      expect(items[0].title, 'Kopi');
      expect(items[0].amount, 20000.0);
      expect(items[0].category, 'Food');
      expect(items[1].title, 'Roti');
      expect(items[1].amount, 15000.0);
      expect(items[1].category, 'Food');
      expect(items[2].title, 'Parkir');
      expect(items[2].amount, 2000.0);
      expect(items[2].category, 'Transport');
    });

    test('parses multiple transactions without explicit conjunction', () {
      final items = NlpTransactionParser.parseAll('matcha 28k esteh 3k');
      expect(items.length, 2);
      expect(items[0].title, 'Matcha');
      expect(items[0].amount, 28000.0);
      expect(items[1].title, 'Esteh');
      expect(items[1].amount, 3000.0);
    });

    test('parses multiple spoken Indonesian number words', () {
      final items = NlpTransactionParser.parseAll('beli kopi dua puluh lima ribu dan donat lima belas ribu');
      expect(items.length, 2);
      expect(items[0].amount, 25000.0);
      expect(items[0].category, 'Food');
      expect(items[1].amount, 15000.0);
      expect(items[1].category, 'Food');
    });
  });
}
