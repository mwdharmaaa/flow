class IndonesianNumberParser {
  static const Map<String, int> _wordMap = {
    'nol': 0,
    'kosong': 0,
    'satu': 1,
    'se': 1,
    'dua': 2,
    'tiga': 3,
    'empat': 4,
    'lima': 5,
    'enam': 6,
    'tujuh': 7,
    'delapan': 8,
    'sembilan': 9,
    'sepuluh': 10,
    'sebelas': 11,
    'seratus': 100,
    'seribu': 1000,
    'sejuta': 1000000,
  };

  static String normalize(String text) {
    String res = text.toLowerCase().trim();
    res = res.replaceAll(RegExp(r'\s+'), ' ');

    // Normalize shorthand: "25 rb" -> "25000", "50k" -> "50000", "2jt" -> "2000000"
    res = res.replaceAllMapped(RegExp(r'(\d+)\s*(?:k|rb|ribu)\b'), (m) => '${m[1]}000');
    res = res.replaceAllMapped(RegExp(r'(\d+)\s*(?:jt|juta)\b'), (m) => '${m[1]}000000');

    // Convert multi-word spoken numbers into digits
    final spokenPatterns = [
      RegExp(r'(?:(?:satu|dua|tiga|empat|lima|enam|tujuh|delapan|sembilan|se)\s*(?:belas|puluh|ratus)?\s*)*(?:ribu|juta)?'),
    ];

    for (final pattern in spokenPatterns) {
      res = res.replaceAllMapped(pattern, (match) {
        final phrase = match.group(0)?.trim() ?? '';
        if (phrase.isEmpty || phrase == 'se') return phrase;
        final numVal = _wordsToNumber(phrase);
        if (numVal != null && numVal > 0) {
          return numVal.toString();
        }
        return phrase;
      });
    }

    return res.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static int? _wordsToNumber(String phrase) {
    final tokens = phrase.split(' ').where((t) => t.isNotEmpty).toList();
    if (tokens.isEmpty) return null;

    int total = 0;
    int current = 0;
    bool hasNumberWord = false;

    for (final t in tokens) {
      if (_wordMap.containsKey(t)) {
        hasNumberWord = true;
        final val = _wordMap[t]!;
        if (val == 100) {
          current = (current == 0 ? 1 : current) * 100;
        } else if (val == 1000) {
          total += (current == 0 ? 1 : current) * 1000;
          current = 0;
        } else if (val == 1000000) {
          total += (current == 0 ? 1 : current) * 1000000;
          current = 0;
        } else {
          current += val;
        }
      } else if (t == 'puluh') {
        hasNumberWord = true;
        current = (current == 0 ? 1 : current) * 10;
      } else if (t == 'belas') {
        hasNumberWord = true;
        current = (current == 0 ? 1 : current) + 10;
      } else if (t == 'ratus') {
        hasNumberWord = true;
        current = (current == 0 ? 1 : current) * 100;
      } else if (t == 'ribu') {
        hasNumberWord = true;
        total += (current == 0 ? 1 : current) * 1000;
        current = 0;
      } else if (t == 'juta') {
        hasNumberWord = true;
        total += (current == 0 ? 1 : current) * 1000000;
        current = 0;
      } else {
        return null;
      }
    }

    total += current;
    return hasNumberWord && total > 0 ? total : null;
  }
}
