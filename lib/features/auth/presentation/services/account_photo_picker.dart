import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/account_photo.dart';

class PhotoSelectionException implements Exception {
  const PhotoSelectionException(this.message);
  final String message;
}

class AccountPhotoPicker {
  final _picker = ImagePicker();
  static const maxBytes = 5 * 1024 * 1024;

  Future<AccountPhoto?> pick() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      return image == null ? null : await _read(image);
    } on PlatformException {
      throw const PhotoSelectionException(AppStrings.photoSelectionFailed);
    }
  }

  Future<AccountPhoto?> recover() async {
    try {
      final response = await _picker.retrieveLostData();
      if (response.exception != null) {
        throw const PhotoSelectionException(AppStrings.photoSelectionFailed);
      }
      final files = response.files;
      return files == null || files.isEmpty ? null : await _read(files.first);
    } on PlatformException {
      throw const PhotoSelectionException(AppStrings.photoSelectionFailed);
    }
  }

  Future<AccountPhoto> _read(XFile file) async {
    if (await file.length() > maxBytes) {
      throw const PhotoSelectionException(AppStrings.photoTooLarge);
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty || bytes.length > maxBytes) {
      throw const PhotoSelectionException(AppStrings.photoTooLarge);
    }
    final String type;
    final String extension;
    if (bytes.length > 3 &&
        bytes[0] == 255 &&
        bytes[1] == 216 &&
        bytes[2] == 255) {
      type = 'image/jpeg';
      extension = 'jpg';
    } else if (bytes.length > 8 &&
        bytes[0] == 137 &&
        bytes[1] == 80 &&
        bytes[2] == 78 &&
        bytes[3] == 71) {
      type = 'image/png';
      extension = 'png';
    } else if (bytes.length > 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
      type = 'image/webp';
      extension = 'webp';
    } else {
      throw const PhotoSelectionException(AppStrings.photoUnsupported);
    }
    return AccountPhoto(bytes: bytes, contentType: type, extension: extension);
  }
}
