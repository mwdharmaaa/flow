import 'package:flow/core/parsers/indonesian_number_parser.dart';

enum VoiceCommandType {
  deleteAllHistory,
  deleteHistoryByDate,
  unknown,
}

class VoiceCommandResult {
  final VoiceCommandType type;
  final String description;
  final DateTime? targetDate;
  final bool isCommand;

  const VoiceCommandResult({
    required this.type,
    required this.description,
    this.targetDate,
    required this.isCommand,
  });

  static const VoiceCommandResult notACommand = VoiceCommandResult(
    type: VoiceCommandType.unknown,
    description: '',
    isCommand: false,
  );
}

class VoiceCommandParser {
  static const Map<String, int> _monthMap = {
    'januari': 1, 'jan': 1, 'january': 1,
    'februari': 2, 'feb': 2, 'february': 2,
    'maret': 3, 'mar': 3, 'march': 3,
    'april': 4, 'apr': 4,
    'mei': 5, 'may': 5,
    'juni': 6, 'jun': 6, 'june': 6,
    'juli': 7, 'jul': 7, 'july': 7,
    'agustus': 8, 'agu': 8, 'agt': 8, 'august': 8, 'aug': 8,
    'september': 9, 'sep': 9, 'sept': 9,
    'oktober': 10, 'okt': 10, 'october': 10, 'oct': 10,
    'november': 11, 'nov': 11,
    'desember': 12, 'des': 12, 'december': 12, 'dec': 12,
  };

  static final RegExp _deleteAllPattern = RegExp(
    r'\b(?:hapus|hilangkan|bersihkan|reset|delete|clear)\s+(?:semua|seluruh|total)\s+(?:history|histori|riwayat|transaksi|catatan)(?:\s+saya)?\b|\b(?:hapus|hilangkan|bersihkan|reset|delete|clear)\s+(?:history|histori|riwayat|transaksi)\s+(?:semua|seluruh|total)\b|\b(?:reset|bersihkan)\s+(?:history|histori|riwayat|transaksi)\b',
    caseSensitive: false,
  );

  static final RegExp _deletePrefixPattern = RegExp(
    r'\b(?:hapus|hilangkan|bersihkan|delete|clear)\s+(?:history|histori|riwayat|transaksi)\b',
    caseSensitive: false,
  );

  static final RegExp _explicitDatePattern = RegExp(
    r'(?:tanggal|tgl)\s+(\d{1,2})(?:\s+([a-zA-Z]+))?(?:\s+(\d{4}))?',
    caseSensitive: false,
  );

  static final RegExp _formattedDatePattern = RegExp(
    r'(\d{1,2})[-/](\d{1,2})(?:[-/](\d{2,4}))?',
  );

  static VoiceCommandResult parse(String input, [DateTime? referenceNow]) {
    final clean = input.trim();
    if (clean.isEmpty) return VoiceCommandResult.notACommand;

    final lower = clean.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // 1. Check Delete All History
    if (_deleteAllPattern.hasMatch(lower)) {
      return const VoiceCommandResult(
        type: VoiceCommandType.deleteAllHistory,
        description: 'Hapus seluruh riwayat transaksi',
        isCommand: true,
      );
    }

    // 2. Check Delete History By Date
    final isDeleteAction = _deletePrefixPattern.hasMatch(lower) ||
        lower.startsWith('hapus') ||
        lower.startsWith('bersihkan');

    if (!isDeleteAction) return VoiceCommandResult.notACommand;

    final now = referenceNow ?? DateTime.now();

    // Check "hari ini"
    if (lower.contains('hari ini')) {
      final targetDate = DateTime(now.year, now.month, now.day);
      return VoiceCommandResult(
        type: VoiceCommandType.deleteHistoryByDate,
        targetDate: targetDate,
        description: 'Hapus riwayat hari ini (${formatDate(targetDate)})',
        isCommand: true,
      );
    }

    // Check "kemarin"
    if (lower.contains('kemarin')) {
      final yesterday = now.subtract(const Duration(days: 1));
      final targetDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
      return VoiceCommandResult(
        type: VoiceCommandType.deleteHistoryByDate,
        targetDate: targetDate,
        description: 'Hapus riwayat kemarin (${formatDate(targetDate)})',
        isCommand: true,
      );
    }

    // Normalize spoken numbers before date regex (e.g. "tanggal sepuluh" -> "tanggal 10")
    final numNormalized = IndonesianNumberParser.normalize(lower);

    // Check formatted date (e.g. 10/10/2026 or 10-10-2026)
    final formatMatch = _formattedDatePattern.firstMatch(numNormalized);
    if (formatMatch != null) {
      final day = int.tryParse(formatMatch.group(1)!) ?? now.day;
      final month = int.tryParse(formatMatch.group(2)!) ?? now.month;
      final rawYear = formatMatch.group(3);
      int year = now.year;
      if (rawYear != null) {
        year = int.tryParse(rawYear) ?? now.year;
        if (year < 100) year += 2000;
      }
      final targetDate = DateTime(year, month, day);
      return VoiceCommandResult(
        type: VoiceCommandType.deleteHistoryByDate,
        targetDate: targetDate,
        description: 'Hapus riwayat tanggal ${formatDate(targetDate)}',
        isCommand: true,
      );
    }

    // Check explicit date (e.g. "tanggal 10 oktober 2026" or "tgl 5")
    final explicitMatch = _explicitDatePattern.firstMatch(numNormalized);
    if (explicitMatch != null) {
      final day = int.tryParse(explicitMatch.group(1)!) ?? now.day;
      final rawMonth = (explicitMatch.group(2) ?? '').toLowerCase();
      final month = _monthMap[rawMonth] ?? now.month;
      final year = int.tryParse(explicitMatch.group(3) ?? '') ?? now.year;
      final targetDate = DateTime(year, month, day);
      return VoiceCommandResult(
        type: VoiceCommandType.deleteHistoryByDate,
        targetDate: targetDate,
        description: 'Hapus riwayat tanggal ${formatDate(targetDate)}',
        isCommand: true,
      );
    }

    return VoiceCommandResult.notACommand;
  }

  static String formatDate(DateTime dt) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }
}
