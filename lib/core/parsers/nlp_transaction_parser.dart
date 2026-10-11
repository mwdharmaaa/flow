import 'package:flow/models/transaction_model.dart';
import 'package:flow/core/parsers/indonesian_number_parser.dart';

class ParsedTransactionResult {
  final double amount;
  final String category;
  final TransactionType type;
  final String title;
  final bool isValid;
  final String? walletName;

  const ParsedTransactionResult({
    required this.amount,
    required this.category,
    required this.type,
    required this.title,
    required this.isValid,
    this.walletName,
  });

  static const ParsedTransactionResult invalid = ParsedTransactionResult(
    amount: 0.0,
    category: 'Other',
    type: TransactionType.expense,
    title: '',
    isValid: false,
    walletName: null,
  );
}

class NlpTransactionParser {
  static const Map<String, List<String>> _categoryKeywords = {
    'Food': [
      'coffee', 'kopi', 'makan', 'lunch', 'dinner', 'sarapan', 'nasi',
      'ayam', 'mie', 'snack', 'jajan', 'burger', 'pizza', 'minum',
      'tea', 'teh', 'esteh', 'es teh', 'matcha', 'maca', 'macha',
      'mat cha', 'mat ca', 'macca', 'matca', 'matsa', 'matsya',
      'masha', 'masya', 'marsha', 'macah', 'matchah', 'greentea',
      'green tea', 'jus', 'juice', 'boba', 'food', 'resto',
      'cafe', 'kafe', 'roti', 'bakso', 'sate', 'soto', 'martabak',
      'eskrim', 'icecream', 'ice cream', 'kue', 'gorengan', 'latte',
      'cappuccino', 'espresso', 'donat', 'donut'
    ],
    'Transport': [
      'grab', 'gojek', 'ojol', 'bensin', 'bbm', 'pertalite', 'pertamax',
      'tol', 'parkir', 'kereta', 'bus', 'mrt', 'tije', 'taxi', 'transport',
      'commuter', 'solar', 'shell', 'angkot', 'maxim'
    ],
    'Shopping': [
      'belanja', 'baju', 'celana', 'sepatu', 'kaos', 'shopee', 'tokped',
      'tokopedia', 'lazada', 'mall', 'shopping', 'skincare', 'makeup',
      'tas', 'jaket', 'supermarket', 'indomaret', 'alfamart'
    ],
    'Bills': [
      'listrik', 'pln', 'air', 'pdam', 'wifi', 'indihome', 'biznet',
      'pulsa', 'kuota', 'tagihan', 'bill', 'iuran', 'bpjs', 'sewa',
      'kontrakan', 'kos', 'pajak', 'ipl', 'token'
    ],
    'Entertainment': [
      'netflix', 'spotify', 'youtube', 'game', 'steam', 'bioskop',
      'nonton', 'film', 'cinema', 'xxi', 'hiburan', 'liburan', 'ticket', 'tiket'
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
      'gaji', 'salary', 'upah', 'honor', 'gajian'
    ],
    'Bonus': [
      'bonus', 'thr', 'tip', 'cuan', 'cashback', 'reimburse', 'reward', 'komisi',
      'uang tip', 'uang rokok', 'undian', 'giveaway'
    ],
    'Gifts Received': [
      'dikasi', 'dikasih', 'hadiah', 'uang jajan', 'duit jajan', 'angpao',
      'pemberian', 'diberi', 'diberikan', 'amplop', 'salam tempel', 'uang saku',
      'duit saku'
    ],
    'Sales': [
      'jualan', 'hasil jualan', 'laku', 'omset', 'omzet', 'penjualan'
    ],
    'Business': [
      'bisnis', 'business', 'proyek', 'freelance', 'klien'
    ],
    'Investment': [
      'dividen', 'profit', 'crypto', 'saham', 'reksadana', 'bunga bank'
    ],
    'Income': [
      'nemu duit', 'nemu uang', 'menemukan uang', 'nemu rejeki', 'nemu rezeki',
      'rejeki nomplok', 'uang kaget', 'dapat rejeki', 'dapet rejeki',
      'dapat rezeki', 'dapet rezeki', 'nemu', 'dapet duit', 'dapat duit',
      'dapet uang', 'dapat uang', 'pemasukan', 'income', 'tambahin ke saldo',
      'tambah ke saldo', 'tambah saldo', 'tambahin saldo', 'isi saldo',
      'top up', 'masuk saldo', 'masuk ke saldo', 'saldo masuk', 'uang masuk',
      'duit masuk', 'transferan masuk', 'terima transfer', 'terima uang',
      'dapat transferan', 'dapet transferan', 'dapat kiriman', 'dapet kiriman',
      'refund'
    ],
  };

  static const Set<String> _incomeCategories = {
    'Salary',
    'Bonus',
    'Gifts Received',
    'Sales',
    'Business',
    'Investment',
    'Income',
  };

  static const Map<String, String> _knownWallets = {
    'cash': 'Cash',
    'tunai': 'Cash',
    'dompet': 'Cash',
    'kantong': 'Cash',
    'gopay': 'GoPay',
    'go-pay': 'GoPay',
    'go pay': 'GoPay',
    'jago': 'Jago',
    'bank jago': 'Jago',
    'bca': 'BCA',
    'mandiri': 'Mandiri',
    'dana': 'DANA',
    'ovo': 'OVO',
    'shopeepay': 'ShopeePay',
    'spay': 'ShopeePay',
    'bri': 'BRI',
    'bni': 'BNI',
    'seabank': 'SeaBank',
    'jenius': 'Jenius',
    'bsi': 'BSI',
    'cimb': 'CIMB',
  };

  static final RegExp _walletPrepositionPattern = RegExp(
    r'\b(?:di|ke|pakai|pake|lewat|masuk\s+ke|masukin\s+ke)\s+(?:wallet\s+|dompet\s+|rekening\s+|akun\s+)?(cash|tunai|dompet|kantong|gopay|go-pay|go\s+pay|jago|bca|mandiri|dana|ovo|shopeepay|spay|bri|bni|seabank|jenius|bsi|cimb)\b|\b(?:wallet|dompet)\s+([a-zA-Z0-9]+)\b',
    caseSensitive: false,
  );

  static final RegExp _leadingPronounPattern = RegExp(
    r'^(?:aku|saya|kita|gue|gua)\s+',
    caseSensitive: false,
  );

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

  static final RegExp _leadingActionVerbPattern = RegExp(
    r'^(?:beli|membeli|pesan|memesan|order|ngorder|bayar|membayar|jajan|buat|untuk|ambil|ngambil|tambahin\s+ke|tambah\s+ke|masuk\s+ke)\s+',
    caseSensitive: false,
  );

  static final RegExp _incomePattern = RegExp(
    r'\b(?:nemu\s+(?:duit|uang|rejeki|rezeki)(?:\s+di\s+jalan)?|menemukan\s+uang|uang\s+di\s+jalan|duit\s+di\s+jalan|rejeki\s+nomplok|uang\s+kaget|dapet\s+(?:duit|uang|rejeki|rezeki)|dapat\s+(?:duit|uang|rejeki|rezeki)|dikasi\s+(?:duit|uang)|dikasih\s+(?:duit|uang)|dikasi|dikasih|diberi\s+(?:uang|duit)|diberikan\s+(?:uang|duit)|amplop(?:an)?|salam\s+tempel|uang\s+saku|duit\s+saku|uang\s+jajan|duit\s+jajan|uang\s+tip|dapat\s+tip|dapet\s+tip|tambahin\s+(?:ke\s+)?saldo|tambah\s+(?:ke\s+)?saldo|isi\s+(?:ke\s+)?saldo|top\s*up|masuk\s+(?:ke\s+)?saldo|saldo\s+masuk|uang\s+masuk|duit\s+masuk|pemasukan|income|gaji|salary|upah|honor|bonus|thr|cuan|komisi|cashback|reimburse(?:ment)?|angpao|transferan(?:\s+masuk)?|terima\s+(?:transfer|uang)|dapet\s+transfer|dapat\s+transfer|hasil\s+jualan|laku|dividen|profit|refund)\b',
    caseSensitive: false,
  );

  static final RegExp _attachedMatchaNumberPattern = RegExp(
    r'\b(?:maca|macha|macca|matca|matsa|matsya|masha|masya|marsha|macah|matchah|matja|mecha|matcha)(?=\d)',
    caseSensitive: false,
  );

  static final RegExp _matchFollowedByAmount = RegExp(
    r'\bmatch\s+(?=\d|k\b|rb\b|ribu\b|jt\b|juta\b)',
    caseSensitive: false,
  );

  static final RegExp _matchaPhoneticPattern = RegExp(
    r'\b(?:maca|macha|macca|matca|matsa|matsya|masha|masya|marsha|macah|matchah|matja|mecha|mat\s*cha|mat\s*ca|match\s*a)\b',
    caseSensitive: false,
  );

  static final RegExp _esTehPhoneticPattern = RegExp(
    r'\b(?:es\s+teh|es\s+te|es\s+tea|ice\s+tea)\b',
    caseSensitive: false,
  );

  static String phoneticNormalize(String input) {
    if (input.isEmpty) return input;
    String res = input;

    // 1. Separate attached matcha and digits: "matcha28k" -> "matcha 28k"
    res = res.replaceAllMapped(_attachedMatchaNumberPattern, (m) => '${m[0]} ');

    // 2. Normalize "match 28k" -> "matcha 28k"
    res = res.replaceAllMapped(_matchFollowedByAmount, (_) => 'matcha ');

    // 3. Normalize all matcha phonetic variants to "matcha"
    res = res.replaceAll(_matchaPhoneticPattern, 'matcha');

    // 4. Normalize common beverage variants like "es teh" -> "esteh"
    res = res.replaceAll(_esTehPhoneticPattern, 'esteh');

    return res;
  }

  static ParsedTransactionResult parse(String input) {
    final all = parseAll(input);
    return all.isNotEmpty ? all.first : ParsedTransactionResult.invalid;
  }

  static List<ParsedTransactionResult> parseAll(String input) {
    final cleanInput = input.trim();
    if (cleanInput.isEmpty) return const [];

    final phoneticallyNormalized = phoneticNormalize(cleanInput);
    final normalized = IndonesianNumberParser.normalize(phoneticallyNormalized);
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

    // Extract target wallet if present (e.g. "di gopay", "pake bca", "masuk ke cash")
    String? detectedWallet;
    final walletMatch = _walletPrepositionPattern.firstMatch(lower);
    if (walletMatch != null) {
      final rawW = (walletMatch.group(1) ?? walletMatch.group(2) ?? '').toLowerCase();
      if (_knownWallets.containsKey(rawW)) {
        detectedWallet = _knownWallets[rawW];
      } else if (rawW.isNotEmpty && rawW != 'jalan') {
        detectedWallet = rawW[0].toUpperCase() + rawW.substring(1).toLowerCase();
      }
    }

    String itemTitle = lower.replaceAll(amountMatch.group(0)!, '');
    if (walletMatch != null && detectedWallet != null) {
      itemTitle = itemTitle.replaceAll(walletMatch.group(0)!, '');
    }

    itemTitle = itemTitle.replaceAll(RegExp(r'\s+'), ' ').trim();
    itemTitle = itemTitle.replaceFirst(_leadingPronounPattern, '').trim();
    itemTitle = itemTitle.replaceFirst(_leadingConjunctionPattern, '').trim();
    itemTitle = itemTitle.replaceFirst(_leadingActionVerbPattern, '').trim();
    if (itemTitle.isEmpty) {
      itemTitle = 'Quick Record';
    }

    final formattedTitle = _formatTitle(itemTitle);

    String detectedCategory = 'Other';
    TransactionType detectedType = TransactionType.expense;

    for (var entry in _categoryKeywords.entries) {
      for (var kw in entry.value) {
        if (lower.contains(kw)) {
          detectedCategory = entry.key;
          break;
        }
      }
      if (detectedCategory != 'Other') break;
    }

    if (_incomeCategories.contains(detectedCategory) || _incomePattern.hasMatch(lower)) {
      detectedType = TransactionType.income;
      if (detectedCategory == 'Other') {
        detectedCategory = 'Income';
      }
    }

    return ParsedTransactionResult(
      amount: finalAmount,
      category: detectedCategory,
      type: detectedType,
      title: formattedTitle,
      isValid: true,
      walletName: detectedWallet,
    );
  }

  static String _formatTitle(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return 'Quick Record';
    return clean
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }
}
