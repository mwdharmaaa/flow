import 'package:flow/core/parsers/indonesian_number_parser.dart';

enum VoiceCommandType {
  deleteAllHistory,
  deleteHistoryByDate,
  restoreHistory,
  addOrUpdateBudget,
  unknown,
}

class VoiceCommandResult {
  final VoiceCommandType type;
  final String description;
  final DateTime? targetDate;
  final String? targetCategory;
  final String? targetWallet;
  final double? targetAmount;
  final bool isCommand;

  const VoiceCommandResult({
    required this.type,
    required this.description,
    this.targetDate,
    this.targetCategory,
    this.targetWallet,
    this.targetAmount,
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

  static final RegExp _restorePattern = RegExp(
    r'\b(?:balikin|kembalikan|pulihkan|restore|undo|batalkan)\s+(?:semua\s+|seluruh\s+)?(?:history|histori|riwayat|transaksi|catatan|data|penghapusan|hapus)(?:\s+saya)?\b|\b(?:undo|restore)\b',
    caseSensitive: false,
  );

  static final RegExp _budgetCommandPattern = RegExp(
    r'\b(?:tambah|tambahin|atur|set|pasang|bikin|buat)\s+(?:budget|anggaran)\b|\b(?:budget|anggaran)\s+(?:baru\s+|tambah\s+)?\b',
    caseSensitive: false,
  );

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

    // 1. Check Restore / Undo History
    if (_restorePattern.hasMatch(lower)) {
      return const VoiceCommandResult(
        type: VoiceCommandType.restoreHistory,
        description: 'Pulihkan riwayat transaksi yang dihapus',
        isCommand: true,
      );
    }

    // 2. Check Add/Set Budget Command
    if (_budgetCommandPattern.hasMatch(lower)) {
      final numNormalized = IndonesianNumberParser.normalize(lower);
      final amountMatch = RegExp(r'(?:rp\.?\s*)?(\d+(?:[.,]\d+)?)\s*(k|rb|ribu|jt|juta|m|mio|million)?\b', caseSensitive: false).firstMatch(numNormalized);
      if (amountMatch != null) {
        String cleanNum = amountMatch.group(1)!;
        if (RegExp(r'^\d{1,3}(?:\.\d{3})+$').hasMatch(cleanNum)) {
          cleanNum = cleanNum.replaceAll('.', '');
        } else {
          cleanNum = cleanNum.replaceAll(',', '.');
        }
        final rawNum = double.tryParse(cleanNum);
        if (rawNum != null && rawNum > 0) {
          final suffix = (amountMatch.group(2) ?? '').toLowerCase();
          double mult = 1.0;
          if (suffix == 'k' || suffix == 'rb' || suffix == 'ribu') {
            mult = 1000.0;
          } else if (suffix == 'jt' || suffix == 'juta' || suffix == 'm' || suffix == 'mio') {
            mult = 1000000.0;
          } else if (rawNum < 1000 && !lower.contains('rp')) {
            mult = 1000.0;
          }
          final finalAmount = rawNum * mult;

          // Check if wallet is mentioned (e.g. "di gopay", "di wallet cash", "di bca")
          final walletMatch = RegExp(
            r'\b(?:di|ke|pada)?\s*(?:wallet\s+|dompet\s+|rekening\s+|akun\s+)?(cash|tunai|dompet|kantong|gopay|go-pay|go\s+pay|jago|bca|mandiri|dana|ovo|shopeepay|spay|bri|bni|seabank|jenius|bsi|cimb)\b|\b(?:wallet|dompet)\s+([a-zA-Z0-9]+)\b',
            caseSensitive: false,
          ).firstMatch(lower);

          String? targetWallet;
          if (walletMatch != null) {
            final rawW = (walletMatch.group(1) ?? walletMatch.group(2) ?? '').toLowerCase();
            if (rawW.isNotEmpty && rawW != 'jalan') {
              const walletMap = {
                'cash': 'Cash', 'tunai': 'Cash', 'dompet': 'Cash', 'kantong': 'Cash',
                'gopay': 'GoPay', 'go-pay': 'GoPay', 'go pay': 'GoPay', 'jago': 'Jago',
                'bca': 'BCA', 'mandiri': 'Mandiri', 'dana': 'DANA',
                'ovo': 'OVO', 'shopeepay': 'ShopeePay', 'spay': 'ShopeePay',
                'bri': 'BRI', 'bni': 'BNI', 'seabank': 'SeaBank',
                'jenius': 'Jenius', 'bsi': 'BSI', 'cimb': 'CIMB',
              };
              targetWallet = walletMap[rawW] ?? (rawW[0].toUpperCase() + rawW.substring(1));
            }
          }

          // Category mapping
          String? targetCategory;
          if (targetWallet == null) {
            if (lower.contains('makan') || lower.contains('food') || lower.contains('kopi') || lower.contains('jajan')) {
              targetCategory = 'Food';
            } else if (lower.contains('transport') || lower.contains('bensin') || lower.contains('ojol')) {
              targetCategory = 'Transport';
            } else if (lower.contains('belanja') || lower.contains('shopping')) {
              targetCategory = 'Shopping';
            } else if (lower.contains('tagihan') || lower.contains('bill') || lower.contains('listrik')) {
              targetCategory = 'Bills';
            } else if (lower.contains('hiburan') || lower.contains('game') || lower.contains('entertainment')) {
              targetCategory = 'Entertainment';
            } else if (lower.contains('kesehatan') || lower.contains('obat') || lower.contains('health')) {
              targetCategory = 'Health';
            } else if (lower.contains('pendidikan') || lower.contains('buku') || lower.contains('education')) {
              targetCategory = 'Education';
            } else {
              final catMatch = RegExp(r'\b(?:buat|untuk|kategori)\s+([a-zA-Z]+)\b', caseSensitive: false).firstMatch(lower);
              if (catMatch != null) {
                final rawCat = catMatch.group(1)!;
                targetCategory = rawCat[0].toUpperCase() + rawCat.substring(1).toLowerCase();
              } else {
                targetCategory = 'General';
              }
            }
          }

          final targetLabel = targetWallet != null ? 'wallet $targetWallet' : 'kategori $targetCategory';
          final formattedAmount = '${finalAmount.toInt()}';
          return VoiceCommandResult(
            type: VoiceCommandType.addOrUpdateBudget,
            description: 'Tambah budget $targetLabel Rp $formattedAmount',
            targetCategory: targetCategory,
            targetWallet: targetWallet,
            targetAmount: finalAmount,
            isCommand: true,
          );
        }
      }
    }

    // 3. Check Delete All History
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
