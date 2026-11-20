import 'package:equatable/equatable.dart';

class ShopSettingsEntity extends Equatable {
  const ShopSettingsEntity({
    required this.shopName,
    required this.phone,
    required this.email,
    this.minimumPaymentPercent = 50,
    this.warningDays = 3,
  });
  final String shopName;
  final String phone;
  final String email;
  final int minimumPaymentPercent;
  final int warningDays;
  @override
  List<Object?> get props => [
    shopName,
    phone,
    email,
    minimumPaymentPercent,
    warningDays,
  ];
}
