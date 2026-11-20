abstract final class MovementAmounts {
  static int? total(int? quantityMilli, int? priceMinor) {
    if (quantityMilli == null ||
        priceMinor == null ||
        quantityMilli <= 0 ||
        priceMinor < 0) {
      return null;
    }
    final result =
        (BigInt.from(quantityMilli) * BigInt.from(priceMinor) +
            BigInt.from(500)) ~/
        BigInt.from(1000);
    return result > BigInt.from(999999999999) ? null : result.toInt();
  }
}
