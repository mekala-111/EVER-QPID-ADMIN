import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

class WebAudioRecorder {
  web.MediaRecorder? _mediaRecorder;
  web.MediaStream? _stream;
  final List<web.Blob> _chunks = [];

  Future<void> start() async {
    _chunks.clear();
    _stream = await web.window.navigator.mediaDevices
        .getUserMedia(web.MediaStreamConstraints(audio: true.toJS))
        .toDart;
    final mimeType = web.MediaRecorder.isTypeSupported(
      'audio/webm;codecs=opus',
    )
        ? 'audio/webm;codecs=opus'
        : 'audio/webm';
    _mediaRecorder = web.MediaRecorder(
      _stream!,
      web.MediaRecorderOptions(mimeType: mimeType),
    );
    _mediaRecorder!.ondataavailable = ((web.Event event) {
      final blob = (event as web.BlobEvent).data;
      if (blob.size > 0) _chunks.add(blob);
    }).toJS;
    _mediaRecorder!.start();
  }

  Future<Uint8List> stop() async {
    final recorder = _mediaRecorder;
    if (recorder == null) {
      throw StateError('MediaRecorder is not initialized.');
    }

    final completer = Completer<Uint8List>();
    recorder.onstop = ((web.Event _) {
      final parts = _chunks.map<JSAny>((blob) => blob).toList().toJS;
      final blob = web.Blob(
        parts,
        web.BlobPropertyBag(type: recorder.mimeType),
      );
      blob.arrayBuffer().toDart.then((buffer) {
        _releaseStream();
        completer.complete(buffer.toDart.asUint8List());
      }, onError: completer.completeError);
    }).toJS;
    recorder.onerror = ((web.Event event) {
      _releaseStream();
      if (!completer.isCompleted) {
        completer.completeError(StateError('Audio recording failed.'));
      }
    }).toJS;
    recorder.stop();
    return completer.future;
  }

  void dispose() {
    _releaseStream();
    _chunks.clear();
  }

  void _releaseStream() {
    for (final track in _stream?.getTracks().toDart ?? const []) {
      track.stop();
    }
    _stream = null;
    _mediaRecorder = null;
  }

  bool get isRecording => _mediaRecorder?.state == 'recording';
}
