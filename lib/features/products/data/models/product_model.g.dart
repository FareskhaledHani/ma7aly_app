// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  unit: json['unit'] as String,
  priceMinor: const SafeIntegerConverter().fromJson(json['priceMinor']),
  costMinor: const NullableSafeIntegerConverter().fromJson(json['costMinor']),
  trackInventory: json['trackInventory'] as bool? ?? false,
  stockMilli: const SafeIntegerConverter().fromJson(json['stockMilli']),
  lowStockMilli: const SafeIntegerConverter().fromJson(json['lowStockMilli']),
  extraUnit: json['extraUnit'] as String?,
);
