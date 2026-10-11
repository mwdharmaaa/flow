import 'speech_recognition_interface.dart';

class SpeechRecognitionStub implements SpeechRecognitionInterface {
  @override
  bool get isSupported => false;

  @override
  void startListening({
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    VoidCallback? onDone,
  }) {
    onError('Perekaman audio native belum tersedia pada platform ini.');
  }

  @override
  void stopListening() {}
}

SpeechRecognitionInterface getSpeechRecognition() => SpeechRecognitionStub();
