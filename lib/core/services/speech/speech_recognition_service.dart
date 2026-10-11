import 'speech_recognition_interface.dart';
import 'speech_recognition_stub.dart'
    if (dart.library.html) 'speech_recognition_web.dart';

class SpeechRecognitionService {
  static final SpeechRecognitionInterface _instance = getSpeechRecognition();
  static SpeechRecognitionInterface get instance => _instance;
}
