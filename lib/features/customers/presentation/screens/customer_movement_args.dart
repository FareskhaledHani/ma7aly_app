import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/customer_movement_entity.dart';

class CustomerMovementArgs {
  const CustomerMovementArgs({
    required this.customer,
    required this.kind,
    required this.balanceMinor,
    this.movement,
  });
  final CustomerEntity customer;
  final CustomerMovementKind kind;
  final int balanceMinor;
  final CustomerMovementEntity? movement;
}
