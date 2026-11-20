import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/customer_input.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/movement_amounts.dart';
import '../../domain/usecases/save_customer_movement_usecase.dart';
import 'save_customer_movement_state.dart';

class SaveCustomerMovementCubit extends Cubit<SaveCustomerMovementState> {
  SaveCustomerMovementCubit(this._save)
    : super(const SaveCustomerMovementState.initial());
  final SaveCustomerMovementUseCase _save;
  int balanceAfter(
    int balance,
    String amount, {
    int previousPaymentMinor = 0,
  }) =>
      balance + previousPaymentMinor - (CustomerInput.moneyMinor(amount) ?? 0);
  int? calculateTotal(String quantity, String price) => MovementAmounts.total(
    CustomerInput.quantityMilli(quantity),
    price.trim().isEmpty ? null : CustomerInput.moneyMinor(price),
  );
  Future<void> save(SaveCustomerMovementParams params) async {
    if (state is MovementLoading || state is MovementSuccess) return;
    emit(const SaveCustomerMovementState.loading());
    final result = await _save(params);
    if (isClosed) return;
    result.when(
      (_) => emit(SaveCustomerMovementState.success(params)),
      (failure) =>
          emit(SaveCustomerMovementState.failure(failure.message, params)),
    );
  }

  Future<void> confirm(MovementFailure failure) => save(
    SaveCustomerMovementParams(
      customerId: failure.params.customerId,
      movement: failure.params.movement,
      expectedRevision: failure.params.expectedRevision,
      delete: failure.params.delete,
      confirmCredit:
          failure.params.confirmCredit ||
          failure.message == AppStrings.confirmCredit,
      confirmNegativeStock:
          failure.params.confirmNegativeStock ||
          failure.message == AppStrings.confirmNegativeStock,
    ),
  );
}
