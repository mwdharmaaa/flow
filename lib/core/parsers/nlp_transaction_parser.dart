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
      'tea', 'boba', 'food', 'resto', 'cafe', 'kafe', 'roti', 'bakso',
      'sate', 'soto', 'martabak', 'eskrim', 'icecream'
    ],
    'Transport': [
      'grab', 'gojek', 'ojol', 'bensin', 'bbm', 'pertalite', 'pertamax',
      'tol', 'parkir', 'kereta', 'bus', 'mrt', 'tije', 'taxi', 'transport',
      'commuter', 'solar', 'shell', 'angkot'
    ],
    'Shopping': [
      'belanja', 'baju', 'celana', 'sepatu', 'kaos', 'shopee', 'tokped',
      'tokopedia', 'lazada', 'mall', 'shopping', 'skincare', 'makeup',
      'tas', 'jaket', 'beli', 'supermarket', 'indomaret', 'alfamart'
    ],
    'Bills': [
      'listrik', 'pln', 'air', 'pdam', 'wifi', 'indihome', 'biznet',
      'pulsa', 'kuota', 'tagihan', 'bill', 'iuran', 'bpjs', 'sewa',
      'kontrakan', 'kos', 'pajak', 'ipl'
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

  static ParsedTransactionResult parse(String input) {
    final cleanInput = input.trim();
    if (cleanInput.isEmpty) return ParsedTransactionResult.invalid;

    final normalized = IndonesianNumberParser.normalize(cleanInput);
    final lower = normalized.toLowerCase();

    // 1. Extract Amount
    final amountMatch = RegExp(
      r'(?:rp\.?\s*)?(\d+(?:[.,]\d+)?)\s*(k|rb|ribu|jt|juta|m|mio|million)?',
      caseSensitive: false,
    ).firstMatch(lower);

    if (amountMatch == null) return ParsedTransactionResult.invalid;

    final numStr = amountMatch.group(1)!.replaceAll(',', '.');
    final rawNum = double.tryParse(numStr);
    if (rawNum == null || rawNum <= 0) return ParsedTransactionResult.invalid;

    final suffix = (amountMatch.group(2) ?? '').toLowerCase();
    double multiplier = 1.0;
    if (suffix == 'k' || suffix == 'rb' || suffix == 'ribu') {
      multiplier = 1000.0;
    } else if (suffix == 'jt' || suffix == 'juta' || suffix == 'm' || suffix == 'mio' || suffix == 'million') {
      multiplier = 1000000.0;
    } else if (rawNum < 1000 && !lower.contains('rp')) {
      // e.g. "coffee 18" -> assume 18k if small integer
      multiplier = 1000.0;
    }

    final finalAmount = rawNum * multiplier;

    // 2. Extract Title / Item description
    String itemTitle = lower
        .replaceAll(amountMatch.group(0)!, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (itemTitle.isEmpty) {
      itemTitle = 'Quick Record';
    }

    // Capitalize first letter of itemTitle
    final formattedTitle = itemTitle[0].toUpperCase() + itemTitle.substring(1);

    // 3. Match Category & TransactionType
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
