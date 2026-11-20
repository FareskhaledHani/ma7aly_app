import 'package:equatable/equatable.dart';

enum CustomerMovementKind { withdrawal, payment }

class CustomerMovementEntity extends Equatable {
  const CustomerMovementEntity({
    required this.id,
    required this.kind,
    required this.amountMinor,
    required this.date,
    this.quantityMilli,
    this.unit,
    this.unitPriceMinor,
    this.note,
    this.paymentMethod,
    this.revision = 1,
    this.deleted = false,
    this.productId,
    this.productName,
    this.trackedInventory = false,
    this.createdAt,
  });

  final String id;
  final CustomerMovementKind kind;
  final int amountMinor;
  final DateTime date;
  final int? quantityMilli;
  final String? unit;
  final int? unitPriceMinor;
  final String? note;
  final String? paymentMethod;
  final int revision;
  final bool deleted;
  final String? productId;
  final String? productName;
  final bool trackedInventory;
  final DateTime? createdAt;

  int get balanceDelta =>
      kind == CustomerMovementKind.withdrawal ? amountMinor : -amountMinor;

  @override
  List<Object?> get props => [
    id,
    kind,
    amountMinor,
    date,
    quantityMilli,
    unit,
    unitPriceMinor,
    note,
    paymentMethod,
    revision,
    deleted,
    productId,
    productName,
    trackedInventory,
    createdAt,
  ];
}
