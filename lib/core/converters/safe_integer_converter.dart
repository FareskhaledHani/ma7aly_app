import 'package:json_annotation/json_annotation.dart';

class SafeIntegerConverter implements JsonConverter<int, Object?> {
  const SafeIntegerConverter();
  @override
  int fromJson(Object? value) {
    final parsed = value is num ? value : num.tryParse(value?.toString() ?? '');
    if (parsed == null ||
        !parsed.isFinite ||
        parsed != parsed.round() ||
        parsed.abs() > 9007199254740991) {
      throw const FormatException('Invalid integer');
    }
    return parsed.toInt();
  }

  @override
  Object toJson(int value) => value;
}

class NullableSafeIntegerConverter implements JsonConverter<int?, Object?> {
  const NullableSafeIntegerConverter();
  @override
  int? fromJson(Object? value) =>
      value == null ? null : const SafeIntegerConverter().fromJson(value);
  @override
  Object? toJson(int? value) => value;
}
