import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/save_customer_movement_usecase.dart';
part 'save_customer_movement_state.freezed.dart';

@freezed
sealed class SaveCustomerMovementState with _$SaveCustomerMovementState {
  const factory SaveCustomerMovementState.initial() = MovementInitial;
  const factory SaveCustomerMovementState.loading() = MovementLoading;
  const factory SaveCustomerMovementState.success(
    SaveCustomerMovementParams params,
  ) = MovementSuccess;
  const factory SaveCustomerMovementState.failure(
    String message,
    SaveCustomerMovementParams params,
  ) = MovementFailure;
}
