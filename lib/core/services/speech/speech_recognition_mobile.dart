import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'speech_recognition_interface.dart';

class SpeechRecognitionMobile implements SpeechRecognitionInterface {
  stt.SpeechToText? _speech;
  bool _isInitialized = false;
  bool _isListening = false;
  bool _userStopped = false;

  String _accumulatedText = '';
  String _currentUtterance = '';

  SpeechResultCallback? _currentOnResult;
  SpeechErrorCallback? _currentOnError;
  VoidCallback? _currentOnDone;

  @override
  bool get isSupported => true;

  @override
  void startListening({
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    VoidCallback? onDone,
  }) async {
    _userStopped = false;
    _accumulatedText = '';
    _currentUtterance = '';
    _currentOnResult = onResult;
    _currentOnError = onError;
    _currentOnDone = onDone;

    try {
      _speech ??= stt.SpeechToText();

      if (!_isInitialized) {
        _isInitialized = await _speech!.initialize(
          onError: _handleError,
          onStatus: _handleStatus,
        );
      }

      if (!_isInitialized) {
        _isListening = false;
        onError('Izin mikrofon tidak diberikan atau pengenalan suara tidak didukung.');
        return;
      }

      _isListening = true;
      await _startListenSession();
    } catch (e) {
      _isListening = false;
      onError('Terjadi kendala saat memulai mikrofon: $e');
    }
  }

  Future<void> _startListenSession() async {
    if (_userStopped || _speech == null) return;

    try {
      String targetLocale = 'id_ID';
      try {
        final locales = await _speech!.locales();
        final id = locales.where((l) => l.localeId.toLowerCase().startsWith('id')).firstOrNull;
        if (id != null) {
          targetLocale = id.localeId;
        }
      } catch (_) {}

      await _speech!.listen(
        onResult: _handleResult,
        localeId: targetLocale,
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 4),
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
          onDevice: false,
        ),
      );
    } catch (_) {}
  }

  void _handleResult(SpeechRecognitionResult result) {
    if (_userStopped || _currentOnResult == null) return;

    String words = result.recognizedWords;

    for (final alt in result.alternates) {
      final altLower = alt.recognizedWords.toLowerCase();
      if (altLower.contains('matcha') ||
          altLower.contains('maca') ||
          altLower.contains('macha') ||
          altLower.contains('mat cha') ||
          altLower.contains('macca') ||
          altLower.contains('matca')) {
        words = alt.recognizedWords;
        break;
      }
    }

    words = words.trim();

    if (result.finalResult) {
      if (words.isNotEmpty) {
        if (_accumulatedText.isNotEmpty && !_accumulatedText.endsWith(' ')) {
          _accumulatedText += ' ';
        }
        _accumulatedText += words;
      }
      _currentUtterance = '';
      _currentOnResult!(_accumulatedText.trim(), true);
    } else {
      _currentUtterance = words;
      final preview = _accumulatedText.isEmpty
          ? _currentUtterance
          : '$_accumulatedText $_currentUtterance';
      _currentOnResult!(preview.trim(), false);
    }
  }

  void _handleError(SpeechRecognitionError errorNotification) {
    if (_userStopped) return;

    final err = errorNotification.errorMsg.toLowerCase();
    if (err.contains('no_match') || err.contains('timeout') || err.contains('speech_timeout')) {
      _restartListeningIfNeeded();
      return;
    }

    _isListening = false;
    if (_currentOnError != null) {
      _currentOnError!('Gagal menangkap suara: ${errorNotification.errorMsg}');
    }
    if (_currentOnDone != null) {
      _currentOnDone!();
    }
  }

  void _handleStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (!_userStopped && _isListening) {
        _restartListeningIfNeeded();
      } else if (_userStopped) {
        _isListening = false;
        if (_currentOnDone != null) {
          _currentOnDone!();
        }
      }
    }
  }

  void _restartListeningIfNeeded() {
    if (_userStopped || !_isListening || _speech == null) return;

    Future.delayed(const Duration(milliseconds: 250), () {
      if (!_userStopped && _isListening && _speech != null && !_speech!.isListening) {
        _startListenSession();
      }
    });
  }

  @override
  void stopListening() {
    _userStopped = true;
    _isListening = false;
    try {
      _speech?.stop();
    } catch (_) {}
  }
}

SpeechRecognitionInterface getSpeechRecognition() => SpeechRecognitionMobile();
