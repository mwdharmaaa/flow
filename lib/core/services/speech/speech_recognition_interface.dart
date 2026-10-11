typedef SpeechResultCallback = void Function(String text, bool isFinal);
typedef SpeechErrorCallback = void Function(String error);

abstract class SpeechRecognitionInterface {
  bool get isSupported;
  void startListening({
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    VoidCallback? onDone,
  });
  void stopListening();
}

typedef VoidCallback = void Function();
