import 'dart:typed_data';

class WebAudioRecorder {
  Future<void> start() {
    throw UnsupportedError('Audio recording is only available on the web.');
  }

  Future<Uint8List> stop() {
    throw UnsupportedError('Audio recording is only available on the web.');
  }

  void dispose() {}

  bool get isRecording => false;
}
