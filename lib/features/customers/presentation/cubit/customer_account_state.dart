import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/customer_account_entity.dart';
part 'customer_account_state.freezed.dart';

@freezed
sealed class CustomerAccountState with _$CustomerAccountState {
  const factory CustomerAccountState.initial() = CustomerAccountInitial;
  const factory CustomerAccountState.loading() = CustomerAccountLoading;
  const factory CustomerAccountState.success(CustomerAccountEntity account) =
      CustomerAccountSuccess;
  const factory CustomerAccountState.failure(String message) =
      CustomerAccountFailure;
}
