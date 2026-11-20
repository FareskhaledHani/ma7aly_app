import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.unit,
    required this.priceMinor,
    this.costMinor,
    this.trackInventory = false,
    this.stockMilli = 0,
    this.lowStockMilli = 0,
    this.extraUnit,
  });
  final String id;
  final String name;
  final String unit;
  final int priceMinor;
  final int? costMinor;
  final bool trackInventory;
  final int stockMilli;
  final int lowStockMilli;
  final String? extraUnit;
  bool get isLowStock => trackInventory && stockMilli <= lowStockMilli;
  @override
  List<Object?> get props => [
    id,
    name,
    unit,
    priceMinor,
    costMinor,
    trackInventory,
    stockMilli,
    lowStockMilli,
    extraUnit,
  ];
}
