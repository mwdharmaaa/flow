import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/parsers/indonesian_number_parser.dart';

void main() {
  group('IndonesianNumberParser Tests', () {
    test('parses nominal words correctly', () {
      expect(IndonesianNumberParser.parseWordsToNumber('seratus ribu'), 100000.0);
      expect(IndonesianNumberParser.parseWordsToNumber('dua juta lima ratus ribu'), 2500000.0);
      expect(IndonesianNumberParser.parseWordsToNumber('sepuluh ribu'), 10000.0);
    });
  });
}
