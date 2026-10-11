import 'dart:typed_data';

class CapturedImageResult {
  final Uint8List bytes;
  final String name;
  final int size;

  const CapturedImageResult({
    required this.bytes,
    required this.name,
    required this.size,
  });
}

abstract class CameraCaptureInterface {
  Future<CapturedImageResult?> captureFromCamera();
  Future<CapturedImageResult?> pickFromGallery();
}
