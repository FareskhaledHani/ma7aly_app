abstract final class CustomerInput {
  static int? quantityMilli(String text) {
    final value = digits(text).trim().replaceAll('٫', '.');
    final match = RegExp(r'^(\d{1,6})(?:\.(\d{1,3}))?$').firstMatch(value);
    if (match == null) return null;
    return int.parse(match.group(1)!) * 1000 +
        int.parse((match.group(2) ?? '').padRight(3, '0'));
  }

  static String decimal(int value, int precision) {
    final scale = precision == 2 ? 100 : 1000;
    final fraction = (value.abs() % scale)
        .toString()
        .padLeft(precision, '0')
        .replaceFirst(RegExp(r'0+$'), '');
    return '${value < 0 ? '-' : ''}${value.abs() ~/ scale}${fraction.isEmpty ? '' : '.$fraction'}';
  }

  static String digits(String text) {
    const ar = '٠١٢٣٤٥٦٧٨٩';
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    return text.split('').map((char) {
      final a = ar.indexOf(char);
      final p = fa.indexOf(char);
      return a >= 0
          ? '$a'
          : p >= 0
          ? '$p'
          : char;
    }).join();
  }

  static String nameKey(String text) => text
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp('[\u064B-\u065F\u0670]'), '')
      .replaceAll(RegExp(r'\s+'), ' ');

  static String phoneKey(String text) =>
      digits(text).replaceAll(RegExp('[^0-9]'), '');

  static int? moneyMinor(String text) {
    final value = digits(text).trim().replaceAll('٫', '.');
    if (value.isEmpty) return 0;
    final match = RegExp(r'^(\d{1,10})(?:\.(\d{1,2}))?$').firstMatch(value);
    if (match == null) return null;
    final whole = int.tryParse(match.group(1) ?? '');
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    if (whole == null) return null;
    return whole * 100 + (int.tryParse(fraction) ?? 0);
  }
}
