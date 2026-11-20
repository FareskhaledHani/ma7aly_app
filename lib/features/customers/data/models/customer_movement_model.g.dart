// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_movement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerMovementModel _$CustomerMovementModelFromJson(
  Map<String, dynamic> json,
) => CustomerMovementModel(
  id: json['id'] as String,
  kind: json['kind'] as String,
  amountMinor: const SafeIntegerConverter().fromJson(json['amountMinor']),
  date: CustomerMovementModel._date(json['date']),
  quantityMilli: const NullableSafeIntegerConverter().fromJson(
    json['quantityMilli'],
  ),
  unit: json['unit'] as String?,
  unitPriceMinor: const NullableSafeIntegerConverter().fromJson(
    json['unitPriceMinor'],
  ),
  note: json['note'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  revision: const SafeIntegerConverter().fromJson(json['revision']),
  deleted: json['deleted'] as bool? ?? false,
  productId: json['productId'] as String?,
  productName: json['productName'] as String?,
  trackedInventory: json['trackedInventory'] as bool? ?? false,
  createdAt: CustomerMovementModel._date(json['createdAt']),
);
