import 'dart:typed_data';

class AccountPhoto {
  const AccountPhoto({
    required this.bytes,
    required this.contentType,
    required this.extension,
  });
  final Uint8List bytes;
  final String contentType;
  final String extension;
}
