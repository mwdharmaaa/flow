import 'package:flow/models/transaction_model.dart';
import 'package:flow/core/parsers/indonesian_number_parser.dart';

class ParsedTransactionResult {
  final double amount;
  final String category;
  final TransactionType type;
  final String title;
  final bool isValid;

  const ParsedTransactionResult({
    required this.amount,
    required this.category,
    required this.type,
    required this.title,
    required this.isValid,
  });

  static const ParsedTransactionResult invalid = ParsedTransactionResult(
    amount: 0.0,
    category: 'Other',
    type: TransactionType.expense,
    title: '',
    isValid: false,
  );
}

class NlpTransactionParser {
  static const Map<String, List<String>> _categoryKeywords = {
    'Food': [
      'coffee', 'kopi', 'makan', 'lunch', 'dinner', 'sarapan', 'nasi',
      'ayam', 'mie', 'snack', 'jajan', 'burger', 'pizza', 'minum',
      'tea', 'teh', 'esteh', 'matcha', 'jus', 'boba', 'food', 'resto',
      'cafe', 'kafe', 'roti', 'bakso', 'sate', 'soto', 'martabak',
      'eskrim', 'icecream', 'kue', 'gorengan'
    ],
    'Transport': [
      'grab', 'gojek', 'ojol', 'bensin', 'bbm', 'pertalite', 'pertamax',
      'tol', 'parkir', 'kereta', 'bus', 'mrt', 'tije', 'taxi', 'transport',
      'commuter', 'solar', 'shell', 'angkot', 'maxim'
    ],
    'Shopping': [
      'belanja', 'baju', 'celana', 'sepatu', 'kaos', 'shopee', 'tokped',
      'tokopedia', 'lazada', 'mall', 'shopping', 'skincare', 'makeup',
      'tas', 'jaket', 'beli', 'supermarket', 'indomaret', 'alfamart'
    ],
    'Bills': [
      'listrik', 'pln', 'air', 'pdam', 'wifi', 'indihome', 'biznet',
      'pulsa', 'kuota', 'tagihan', 'bill', 'iuran', 'bpjs', 'sewa',
      'kontrakan', 'kos', 'pajak', 'ipl', 'token'
    ],
    'Entertainment': [
      'netflix', 'spotify', 'youtube', 'game', 'steam', 'bioskop',
      'nonton', 'film', 'cinema', 'xxi', 'hiburan', 'liburan', 'ticket'
    ],
    'Health': [
      'obat', 'dokter', 'apotek', 'vitamin', 'rs', 'klinik', 'sehat',
      'health', 'medical', 'gym', 'fitness', 'masker'
    ],
    'Education': [
      'buku', 'kursus', 'sekolah', 'kuliah', 'udemy', 'course', 'les',
      'education', 'seminar', 'training'
    ],
    'Salary': [
      'gaji', 'salary', 'bonus', 'thr', 'income', 'pemasukan', 'upah',
      'proyek', 'freelance', 'dividen', 'cuan', 'transferan'
    ],
  };

  static final RegExp _amountPattern = RegExp(
    r'(?:rp\.?\s*)?(\d+(?:[.,]\d+)?)\s*(k|rb|ribu|jt|juta|m|mio|million)?\b',
    caseSensitive: false,
  );

  static final RegExp _conjunctionSplitter = RegExp(
    r'(?:,|\b(?:dan\s+juga|dan|sama|serta|lalu|terus|kemudian|tambah|plus|juga|&)\b|\n|;)',
    caseSensitive: false,
  );

  static final RegExp _leadingConjunctionPattern = RegExp(
    r'^(?:dan\s+juga|dan|sama|serta|lalu|terus|kemudian|juga|tambah|plus|&|\+|-)\s+',
    caseSensitive: false,
  );

  static ParsedTransactionResult parse(String input) {
    final all = parseAll(input);
    return all.isNotEmpty ? all.first : ParsedTransactionResult.invalid;
  }

  static List<ParsedTransactionResult> parseAll(String input) {
    final cleanInput = input.trim();
    if (cleanInput.isEmpty) return const [];

    final normalized = IndonesianNumberParser.normalize(cleanInput);
    if (normalized.isEmpty) return const [];

    final rawSegments = normalized.split(_conjunctionSplitter);
    final List<String> segments = [];

    for (final seg in rawSegments) {
      final trimmed = seg.trim();
      if (trimmed.isEmpty) continue;
      final matches = _amountPattern.allMatches(trimmed).toList();
      if (matches.length > 1) {
        segments.addAll(_subdivideSegment(trimmed, matches));
      } else {
        segments.add(trimmed);
      }
    }

    final List<ParsedTransactionResult> results = [];
    for (final seg in segments) {
      final res = _parseSegment(seg);
      if (res.isValid) results.add(res);
    }
    return results;
  }

  static List<String> _subdivideSegment(String text, List<RegExpMatch> matches) {
    if (matches.length <= 1) return [text];
    final isPrefix = matches.first.start <= 2;
    final List<String> subs = [];
    int prev = 0;

    for (int i = isPrefix ? 1 : 0; i < (isPrefix ? matches.length : matches.length - 1); i++) {
      final idx = isPrefix ? matches[i].start : matches[i].end;
      subs.add(text.substring(prev, idx).trim());
      prev = idx;
    }
    subs.add(text.substring(prev).trim());
    return subs.where((s) => s.isNotEmpty).toList();
  }

  static ParsedTransactionResult _parseSegment(String segment) {
    final clean = segment.trim();
    if (clean.isEmpty) return ParsedTransactionResult.invalid;

    final lower = clean.toLowerCase();
    final amountMatch = _amountPattern.firstMatch(lower);
    if (amountMatch == null) return ParsedTransactionResult.invalid;

    String cleanNum = amountMatch.group(1)!;
    if (RegExp(r'^\d{1,3}(?:\.\d{3})+$').hasMatch(cleanNum)) {
      cleanNum = cleanNum.replaceAll('.', '');
    } else {
      cleanNum = cleanNum.replaceAll(',', '.');
    }

    final rawNum = double.tryParse(cleanNum);
    if (rawNum == null || rawNum <= 0) return ParsedTransactionResult.invalid;

    final suffix = (amountMatch.group(2) ?? '').toLowerCase();
    double multiplier = 1.0;
    if (suffix == 'k' || suffix == 'rb' || suffix == 'ribu') {
      multiplier = 1000.0;
    } else if (suffix == 'jt' || suffix == 'juta' || suffix == 'm' || suffix == 'mio' || suffix == 'million') {
      multiplier = 1000000.0;
    } else if (rawNum < 1000 && !lower.contains('rp')) {
      multiplier = 1000.0;
    }

    final finalAmount = rawNum * multiplier;

    String itemTitle = lower
        .replaceAll(amountMatch.group(0)!, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    itemTitle = itemTitle.replaceFirst(_leadingConjunctionPattern, '').trim();
    if (itemTitle.isEmpty) {
      itemTitle = 'Quick Record';
    }

    final formattedTitle = itemTitle[0].toUpperCase() + itemTitle.substring(1);

    String detectedCategory = 'Other';
    TransactionType detectedType = TransactionType.expense;

    for (var entry in _categoryKeywords.entries) {
      for (var kw in entry.value) {
        if (lower.contains(kw)) {
          detectedCategory = entry.key;
          if (entry.key == 'Salary') {
            detectedType = TransactionType.income;
          }
          break;
        }
      }
      if (detectedCategory != 'Other') break;
    }

    return ParsedTransactionResult(
      amount: finalAmount,
      category: detectedCategory,
      type: detectedType,
      title: formattedTitle,
      isValid: true,
    );
  }
}
