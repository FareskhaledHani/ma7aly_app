import 'package:json_annotation/json_annotation.dart';

import '../../../../core/converters/safe_integer_converter.dart';

import '../../domain/entities/product_entity.dart';
part 'product_model.g.dart';

@JsonSerializable(createToJson: false)
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.priceMinor,
    this.costMinor,
    required this.trackInventory,
    required this.stockMilli,
    required this.lowStockMilli,
    this.extraUnit,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  final String id;
  final String name;
  final String unit;
  @SafeIntegerConverter()
  final int priceMinor;
  @NullableSafeIntegerConverter()
  final int? costMinor;
  @JsonKey(defaultValue: false)
  final bool trackInventory;
  @SafeIntegerConverter()
  final int stockMilli;
  @SafeIntegerConverter()
  final int lowStockMilli;
  final String? extraUnit;
  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    unit: unit,
    priceMinor: priceMinor,
    costMinor: costMinor,
    trackInventory: trackInventory,
    stockMilli: stockMilli,
    lowStockMilli: lowStockMilli,
    extraUnit: extraUnit,
  );
}
