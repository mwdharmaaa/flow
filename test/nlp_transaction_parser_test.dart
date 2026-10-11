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

    test('parses all phonetic variants of matcha with high sensitivity', () {
      final variants = [
        'maca 28k',
        'macha 28k',
        'mat cha 28k',
        'mat ca 28k',
        'macca 28k',
        'matca 28k',
        'masha 28k',
        'marsha 28k',
        'matsa 28k',
        'matsya 28k',
        'match a 28k',
        'matchah 28k',
      ];

      for (final text in variants) {
        final res = NlpTransactionParser.parse(text);
        expect(res.isValid, isTrue, reason: 'Failed for "$text"');
        expect(res.title, 'Matcha', reason: 'Title mismatch for "$text"');
        expect(res.amount, 28000.0, reason: 'Amount mismatch for "$text"');
        expect(res.category, 'Food', reason: 'Category mismatch for "$text"');
      }
    });

    test('parses spoken matcha phrases with verbs and multi-items', () {
      final res1 = NlpTransactionParser.parse('beli maca dua puluh delapan ribu');
      expect(res1.isValid, isTrue);
      expect(res1.title, 'Matcha');
      expect(res1.amount, 28000.0);
      expect(res1.category, 'Food');

      final res2 = NlpTransactionParser.parse('pesan macha 28k');
      expect(res2.isValid, isTrue);
      expect(res2.title, 'Matcha');
      expect(res2.amount, 28000.0);
      expect(res2.category, 'Food');

      final items1 = NlpTransactionParser.parseAll('maca 28k dan esteh 3k');
      expect(items1.length, 2);
      expect(items1[0].title, 'Matcha');
      expect(items1[0].amount, 28000.0);
      expect(items1[0].category, 'Food');
      expect(items1[1].title, 'Esteh');
      expect(items1[1].amount, 3000.0);
      expect(items1[1].category, 'Food');

      final items2 = NlpTransactionParser.parseAll('mat cha 28k dan es teh 3k');
      expect(items2.length, 2);
      expect(items2[0].title, 'Matcha');
      expect(items2[0].amount, 28000.0);
      expect(items2[0].category, 'Food');
      expect(items2[1].title, 'Esteh');
      expect(items2[1].amount, 3000.0);
      expect(items2[1].category, 'Food');

      final res3 = NlpTransactionParser.parse('maca latte 28k');
      expect(res3.isValid, isTrue);
      expect(res3.title, 'Matcha Latte');
      expect(res3.amount, 28000.0);
      expect(res3.category, 'Food');
    });
  });
}
