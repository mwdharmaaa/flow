import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'speech_recognition_interface.dart';

class SpeechRecognitionMobile implements SpeechRecognitionInterface {
  stt.SpeechToText? _speech;
  bool _isInitialized = false;
  bool _isListening = false;

  @override
  bool get isSupported => true;

  @override
  void startListening({
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    VoidCallback? onDone,
  }) async {
    try {
      _speech ??= stt.SpeechToText();

      if (!_isInitialized) {
        _isInitialized = await _speech!.initialize(
          onError: (errorNotification) {
            _isListening = false;
            final msg = errorNotification.errorMsg.trim();
            onError('Gagal menangkap suara: ${msg.isNotEmpty ? msg : "Akses mikrofon bermasalah"}');
            if (onDone != null) onDone();
          },
          onStatus: (status) {
            if (status == 'done' || status == 'notListening') {
              if (_isListening) {
                _isListening = false;
                if (onDone != null) onDone();
              }
            }
          },
        );
      }

      if (!_isInitialized) {
        _isListening = false;
        onError('Izin mikrofon tidak diberikan atau pengenalan suara tidak didukung.');
        return;
      }

      _isListening = true;

      String? targetLocale = 'id_ID';
      try {
        final locales = await _speech!.locales();
        final idLocale = locales.where((l) => l.localeId.toLowerCase().startsWith('id')).firstOrNull;
        if (idLocale != null) {
          targetLocale = idLocale.localeId;
        } else if (locales.isNotEmpty) {
          targetLocale = locales.first.localeId;
        }
      } catch (_) {}

      await _speech!.listen(
        onResult: (result) {
          final words = result.recognizedWords;
          if (words.isNotEmpty) {
            onResult(words, result.finalResult);
          }
        },
        localeId: targetLocale,
        listenMode: stt.ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
      );
    } catch (e) {
      _isListening = false;
      onError('Terjadi kendala saat memulai mikrofon: $e');
    }
  }

  @override
  void stopListening() {
    if (_isListening && _speech != null) {
      _isListening = false;
      try {
        _speech!.stop();
      } catch (_) {}
    }
  }
}

SpeechRecognitionInterface getSpeechRecognition() => SpeechRecognitionMobile();
