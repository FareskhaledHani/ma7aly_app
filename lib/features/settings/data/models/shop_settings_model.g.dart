// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopSettingsModel _$ShopSettingsModelFromJson(Map<String, dynamic> json) =>
    ShopSettingsModel(
      shopName: json['shopName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      minimumPaymentPercent: json['minimumPaymentPercent'] == null
          ? 50
          : const SafeIntegerConverter().fromJson(
              json['minimumPaymentPercent'],
            ),
      warningDays: json['warningDays'] == null
          ? 3
          : const SafeIntegerConverter().fromJson(json['warningDays']),
    );
