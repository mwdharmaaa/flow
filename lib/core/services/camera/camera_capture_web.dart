import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'camera_capture_interface.dart';

class CameraCaptureWeb implements CameraCaptureInterface {
  @override
  Future<CapturedImageResult?> captureFromCamera() {
    return _pickFile(captureEnvironment: true);
  }

  @override
  Future<CapturedImageResult?> pickFromGallery() {
    return _pickFile(captureEnvironment: false);
  }

  Future<CapturedImageResult?> _pickFile({required bool captureEnvironment}) {
    final completer = Completer<CapturedImageResult?>();
    final input = html.FileUploadInputElement()..accept = 'image/*';

    if (captureEnvironment) {
      input.setAttribute('capture', 'environment');
    }

    input.onChange.listen((event) {
      final files = input.files;
      if (files == null || files.isEmpty) {
        completer.complete(null);
        return;
      }

      final file = files[0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((_) {
        final result = reader.result;
        if (result is Uint8List) {
          completer.complete(CapturedImageResult(
            bytes: result,
            name: file.name,
            size: file.size,
          ));
        } else if (result is ByteBuffer) {
          completer.complete(CapturedImageResult(
            bytes: Uint8List.view(result),
            name: file.name,
            size: file.size,
          ));
        } else {
          completer.complete(null);
        }
      });

      reader.onError.listen((_) => completer.complete(null));
      reader.readAsArrayBuffer(file);
    });

    input.click();
    return completer.future;
  }
}

CameraCaptureInterface getCameraCapture() => CameraCaptureWeb();
