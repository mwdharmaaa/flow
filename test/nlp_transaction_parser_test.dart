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

    test('parses income voice commands accurately', () {
      final res1 = NlpTransactionParser.parse('dapet duit 30k');
      expect(res1.isValid, isTrue);
      expect(res1.type, TransactionType.income);
      expect(res1.amount, 30000.0);
      expect(res1.category, 'Income');

      final res2 = NlpTransactionParser.parse('dikasi duit 8k');
      expect(res2.isValid, isTrue);
      expect(res2.type, TransactionType.income);
      expect(res2.amount, 8000.0);
      expect(res2.category, 'Gifts Received');

      final res3 = NlpTransactionParser.parse('dikasih duit 8k');
      expect(res3.isValid, isTrue);
      expect(res3.type, TransactionType.income);
      expect(res3.amount, 8000.0);
      expect(res3.category, 'Gifts Received');

      final res4 = NlpTransactionParser.parse('tambahin ke saldo 100k');
      expect(res4.isValid, isTrue);
      expect(res4.type, TransactionType.income);
      expect(res4.amount, 100000.0);
      expect(res4.category, 'Income');

      final res5 = NlpTransactionParser.parse('tambahin ke saldo bca 100k');
      expect(res5.isValid, isTrue);
      expect(res5.type, TransactionType.income);
      expect(res5.title, 'Saldo Bca');
      expect(res5.amount, 100000.0);
      expect(res5.category, 'Income');

      final res6 = NlpTransactionParser.parse('dapat uang lima puluh ribu');
      expect(res6.isValid, isTrue);
      expect(res6.type, TransactionType.income);
      expect(res6.amount, 50000.0);
      expect(res6.category, 'Income');

      final mixed = NlpTransactionParser.parseAll('dapet duit 30k dan matcha 28k');
      expect(mixed.length, 2);
      expect(mixed[0].type, TransactionType.income);
      expect(mixed[0].amount, 30000.0);
      expect(mixed[1].type, TransactionType.expense);
      expect(mixed[1].title, 'Matcha');
      expect(mixed[1].amount, 28000.0);
      expect(mixed[1].category, 'Food');
    });

    test('parses unexpected income expressions like nemu duit di jalan', () {
      final res1 = NlpTransactionParser.parse('nemu duit di jalan 50k');
      expect(res1.isValid, isTrue);
      expect(res1.type, TransactionType.income);
      expect(res1.amount, 50000.0);
      expect(res1.category, 'Income');
      expect(res1.walletName, isNull);

      final res2 = NlpTransactionParser.parse('nemu uang 20 ribu di kasur');
      expect(res2.isValid, isTrue);
      expect(res2.type, TransactionType.income);
      expect(res2.amount, 20000.0);
      expect(res2.category, 'Income');

      final res3 = NlpTransactionParser.parse('dapet rejeki nomplok 500k di BCA');
      expect(res3.isValid, isTrue);
      expect(res3.type, TransactionType.income);
      expect(res3.amount, 500000.0);
      expect(res3.category, 'Bonus');
      expect(res3.walletName, 'BCA');

      final res4 = NlpTransactionParser.parse('dikasi duit 100k di GoPay');
      expect(res4.isValid, isTrue);
      expect(res4.type, TransactionType.income);
      expect(res4.amount, 100000.0);
      expect(res4.category, 'Gifts Received');
      expect(res4.walletName, 'GoPay');

      final res5 = NlpTransactionParser.parse('dikasih uang saku 50rb di dompet cash');
      expect(res5.isValid, isTrue);
      expect(res5.type, TransactionType.income);
      expect(res5.amount, 50000.0);
      expect(res5.category, 'Gifts Received');
      expect(res5.walletName, 'Cash');
    });
  });
}
