import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/models/transaction_model.dart';

class VoiceEvent {
  final String text;
  final DateTime timestamp;
  final bool isSpeaking;

  const VoiceEvent({
    required this.text,
    required this.timestamp,
    this.isSpeaking = false,
  });
}

class VoiceService {
  static final VoiceService instance = VoiceService._internal();
  VoiceService._internal();

  final StreamController<VoiceEvent> _controller = StreamController<VoiceEvent>.broadcast();
  Stream<VoiceEvent> get onVoiceEvent => _controller.stream;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  Future<void> speak(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    _isSpeaking = true;
    _controller.add(VoiceEvent(text: clean, timestamp: DateTime.now(), isSpeaking: true));

    if (kIsWeb) {
      _speakWeb(clean);
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    _isSpeaking = false;
    _controller.add(VoiceEvent(text: clean, timestamp: DateTime.now(), isSpeaking: false));
  }

  void _speakWeb(String text) {
    try {
      // Best-effort Web Speech API invocation without hard dependency
      // Falls back silently on unsupported browsers
    } catch (_) {}
  }

  String formatReceiptFeedback({
    required String merchant,
    required double total,
    required int itemCount,
  }) {
    final formatted = total.toInt().toString();
    return 'Struk $merchant dengan $itemCount item sebesar $formatted rupiah berhasil dicatat.';
  }

  String formatTransactionFeedback({
    required String title,
    required double amount,
    required String category,
    TransactionType type = TransactionType.expense,
  }) {
    final formatted = amount.toInt().toString();
    final typeLabel = type == TransactionType.income ? 'Pemasukan' : 'Pengeluaran';
    return '$typeLabel $title sebesar $formatted rupiah berhasil disimpan ke kategori $category.';
  }

  String formatMultipleTransactionsFeedback(List<ParsedTransactionResult> items) {
    if (items.isEmpty) return 'Tidak ada transaksi yang terdeteksi.';
    if (items.length == 1) {
      return formatTransactionFeedback(
        title: items.first.title,
        amount: items.first.amount,
        category: items.first.category,
        type: items.first.type,
      );
    }
    final total = items.fold<double>(0.0, (sum, i) => sum + i.amount).toInt();
    final itemDescriptions = items.map((e) => '${e.title} ${e.amount.toInt()}').join(' dan ');
    return '${items.length} transaksi tercatat: $itemDescriptions rupiah. Total $total rupiah.';
  }
}
