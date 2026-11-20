import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_identity_entity.dart';
part 'home_identity_model.g.dart';

@JsonSerializable(createToJson: false)
class HomeIdentityModel {
  const HomeIdentityModel({required this.ownerName, required this.shopName});
  factory HomeIdentityModel.fromJson(Map<String, dynamic> json) =>
      _$HomeIdentityModelFromJson(json);
  @JsonKey(defaultValue: '')
  final String ownerName;
  @JsonKey(defaultValue: '')
  final String shopName;
  HomeIdentityEntity toEntity() =>
      HomeIdentityEntity(ownerName: ownerName, shopName: shopName);
}
