import 'package:equatable/equatable.dart';

class HomeIdentityEntity extends Equatable {
  const HomeIdentityEntity({required this.ownerName, required this.shopName});
  final String ownerName;
  final String shopName;
  @override
  List<Object?> get props => [ownerName, shopName];
}
