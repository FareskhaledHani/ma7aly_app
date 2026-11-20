import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/converters/safe_integer_converter.dart';

import '../../domain/entities/customer_movement_entity.dart';

part 'customer_movement_model.g.dart';

@JsonSerializable(createToJson: false)
class CustomerMovementModel {
  const CustomerMovementModel({
    required this.id,
    required this.kind,
    required this.amountMinor,
    required this.date,
    this.quantityMilli,
    this.unit,
    this.unitPriceMinor,
    this.note,
    this.paymentMethod,
    required this.revision,
    required this.deleted,
    this.productId,
    this.productName,
    required this.trackedInventory,
    this.createdAt,
  });
  factory CustomerMovementModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerMovementModelFromJson(json);
  final String id;
  final String kind;
  @SafeIntegerConverter()
  final int amountMinor;
  @JsonKey(fromJson: _date)
  final DateTime? date;
  @NullableSafeIntegerConverter()
  final int? quantityMilli;
  final String? unit;
  @NullableSafeIntegerConverter()
  final int? unitPriceMinor;
  final String? note;
  final String? paymentMethod;
  @SafeIntegerConverter()
  final int revision;
  @JsonKey(defaultValue: false)
  final bool deleted;
  final String? productId;
  final String? productName;
  @JsonKey(defaultValue: false)
  final bool trackedInventory;
  @JsonKey(fromJson: _date)
  final DateTime? createdAt;

  CustomerMovementEntity toEntity() {
    final value = date;
    if (value == null) throw const FormatException('Invalid movement date');
    return CustomerMovementEntity(
      id: id,
      kind: CustomerMovementKind.values.firstWhere((k) => k.name == kind),
      amountMinor: amountMinor,
      date: value,
      quantityMilli: quantityMilli,
      unit: unit,
      unitPriceMinor: unitPriceMinor,
      note: note,
      paymentMethod: paymentMethod,
      revision: revision,
      deleted: deleted,
      productId: productId,
      productName: productName,
      trackedInventory: trackedInventory,
      createdAt: createdAt,
    );
  }

  static DateTime? _date(Object? value) => value is Timestamp
      ? value.toDate().toUtc()
      : value is String
      ? DateTime.tryParse(value)
      : null;
}
