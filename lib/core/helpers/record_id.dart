import 'dart:convert';
import 'dart:math';

abstract final class RecordId {
  static String create() {
    final random = Random.secure();
    return base64UrlEncode(List.generate(16, (_) => random.nextInt(256)))
        .replaceAll('=', '');
  }
}
