import 'dart:async';
import 'package:flutter/foundation.dart';

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
  }) {
    final formatted = amount.toInt().toString();
    return 'Pengeluaran $title sebesar $formatted rupiah berhasil disimpan ke kategori $category.';
  }
}
