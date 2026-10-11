import 'camera_capture_interface.dart';
import 'camera_capture_stub.dart'
    if (dart.library.html) 'camera_capture_web.dart';

class CameraCaptureService {
  static final CameraCaptureInterface _instance = getCameraCapture();
  static CameraCaptureInterface get instance => _instance;
}
