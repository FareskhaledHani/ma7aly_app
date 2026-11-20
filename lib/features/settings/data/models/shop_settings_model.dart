import 'package:json_annotation/json_annotation.dart';

import '../../../../core/converters/safe_integer_converter.dart';

import '../../domain/entities/shop_settings_entity.dart';
part 'shop_settings_model.g.dart';

@JsonSerializable(createToJson: false)
class ShopSettingsModel {
  const ShopSettingsModel({
    required this.shopName,
    required this.phone,
    required this.email,
    required this.minimumPaymentPercent,
    required this.warningDays,
  });
  factory ShopSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ShopSettingsModelFromJson(json);
  @JsonKey(defaultValue: '')
  final String shopName;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: 50)
  @SafeIntegerConverter()
  final int minimumPaymentPercent;
  @JsonKey(defaultValue: 3)
  @SafeIntegerConverter()
  final int warningDays;
  ShopSettingsEntity toEntity() => ShopSettingsEntity(
    shopName: shopName,
    phone: phone,
    email: email,
    minimumPaymentPercent: minimumPaymentPercent,
    warningDays: warningDays,
  );
}
