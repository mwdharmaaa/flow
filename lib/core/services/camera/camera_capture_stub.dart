import 'camera_capture_interface.dart';

class CameraCaptureStub implements CameraCaptureInterface {
  @override
  Future<CapturedImageResult?> captureFromCamera() async {
    return null;
  }

  @override
  Future<CapturedImageResult?> pickFromGallery() async {
    return null;
  }
}

CameraCaptureInterface getCameraCapture() => CameraCaptureStub();
