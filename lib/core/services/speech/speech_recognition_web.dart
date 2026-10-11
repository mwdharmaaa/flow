import 'dart:html' as html;
import 'speech_recognition_interface.dart';

class SpeechRecognitionWeb implements SpeechRecognitionInterface {
  html.SpeechRecognition? _recognition;
  bool _listening = false;

  @override
  bool get isSupported => html.SpeechRecognition.supported;

  @override
  void startListening({
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    VoidCallback? onDone,
  }) {
    if (!isSupported) {
      onError('Browser ini belum mendukung Web Speech Recognition API.');
      return;
    }

    try {
      _stopCurrent();

      final rec = html.SpeechRecognition();
      rec.lang = 'id-ID';
      rec.continuous = true;
      rec.interimResults = true;

      rec.onResult.listen((event) {
        final results = event.results;
        if (results == null || results.isEmpty) return;

        final buffer = StringBuffer();
        for (var i = 0; i < results.length; i++) {
          final res = results[i];
          final part = res.item(0)?.transcript ?? '';
          if (part.isNotEmpty) {
            if (buffer.isNotEmpty) buffer.write(' ');
            buffer.write(part);
          }
        }

        final combined = buffer.toString().trim();
        final isLastFinal = results.last.isFinal ?? false;

        onResult(combined, isLastFinal);
      });

      rec.onError.listen((err) {
        _listening = false;
        onError('Gagal menangkap suara: ${err.error ?? "Akses mikrofon ditolak"}');
      });

      rec.onEnd.listen((_) {
        _listening = false;
        if (onDone != null) onDone();
      });

      _recognition = rec;
      rec.start();
      _listening = true;
    } catch (e) {
      _listening = false;
      onError('Terjadi kendala saat memulai mikrofon: $e');
    }
  }

  @override
  void stopListening() {
    _stopCurrent();
  }

  void _stopCurrent() {
    if (_listening && _recognition != null) {
      try {
        _recognition!.stop();
      } catch (_) {}
      _listening = false;
    }
  }
}

SpeechRecognitionInterface getSpeechRecognition() => SpeechRecognitionWeb();
