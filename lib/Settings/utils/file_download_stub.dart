import 'dart:typed_data';

void downloadBytes(
  Uint8List bytes, {
  required String fileName,
  required String mimeType,
}) {
  throw UnsupportedError('Browser downloads are only available on the web.');
}
