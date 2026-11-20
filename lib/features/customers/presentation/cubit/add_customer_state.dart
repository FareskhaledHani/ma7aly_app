import 'package:freezed_annotation/freezed_annotation.dart';
part 'add_customer_state.freezed.dart';

@freezed
sealed class AddCustomerState with _$AddCustomerState {
  const factory AddCustomerState.initial() = AddCustomerInitial;
  const factory AddCustomerState.loading() = AddCustomerLoading;
  const factory AddCustomerState.success(String id) = AddCustomerSuccess;
  const factory AddCustomerState.failure(String message) = AddCustomerFailure;
}
