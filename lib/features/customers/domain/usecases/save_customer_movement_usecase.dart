import 'package:equatable/equatable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../../../../core/utils/app_strings.dart';
import '../entities/customer_movement_entity.dart';
import '../entities/movement_amounts.dart';
import '../repositories/customers_repository.dart';

class SaveCustomerMovementParams extends Equatable {
  const SaveCustomerMovementParams({
    required this.customerId,
    required this.movement,
    this.expectedRevision,
    this.delete = false,
    this.confirmCredit = false,
    this.confirmNegativeStock = false,
  });
  final String customerId;
  final CustomerMovementEntity movement;
  final int? expectedRevision;
  final bool delete;
  final bool confirmCredit;
  final bool confirmNegativeStock;
  @override
  List<Object?> get props => [
    customerId,
    movement,
    expectedRevision,
    delete,
    confirmCredit,
    confirmNegativeStock,
  ];
}

class SaveCustomerMovementUseCase
    extends UseCase<void, SaveCustomerMovementParams> {
  SaveCustomerMovementUseCase(this._repository);
  final CustomersRepository _repository;
  @override
  Future<Result<void, Failure>> call(SaveCustomerMovementParams params) {
    final m = params.movement;
    final invalidTotal =
        !params.delete &&
        m.quantityMilli != null &&
        m.unitPriceMinor != null &&
        MovementAmounts.total(m.quantityMilli, m.unitPriceMinor) !=
            m.amountMinor;
    if (!RegExp(r'^[A-Za-z0-9_-]{22}$').hasMatch(m.id) ||
        invalidTotal ||
        (params.expectedRevision != null && params.expectedRevision! < 1) ||
        (m.productId == null &&
            (m.productName != null || m.trackedInventory)) ||
        (m.productId != null &&
            ((m.productName?.trim().isEmpty ?? true) ||
                (m.unit?.trim().isEmpty ?? true))) ||
        (m.kind == CustomerMovementKind.payment &&
            (m.quantityMilli != null ||
                m.unitPriceMinor != null ||
                m.unit != null ||
                (m.paymentMethod?.trim().isEmpty ?? true))) ||
        !RegExp(r'^[A-Za-z0-9_-]{22}$').hasMatch(params.customerId) ||
        m.productId != null &&
            (!RegExp(r'^[A-Za-z0-9_-]{22}$').hasMatch(m.productId!) ||
                m.quantityMilli == null ||
                m.kind != CustomerMovementKind.withdrawal) ||
        m.amountMinor <= 0 ||
        m.amountMinor > 999999999999 ||
        m.date.year < 2000 ||
        m.date.year > 2100 ||
        (m.note?.length ?? 0) > 300 ||
        (m.unit?.length ?? 0) > 24 ||
        (m.paymentMethod?.length ?? 0) > 50 ||
        (m.quantityMilli != null &&
            (m.quantityMilli! <= 0 || m.quantityMilli! > 999999999)) ||
        (m.unitPriceMinor != null &&
            (m.unitPriceMinor! < 0 || m.unitPriceMinor! > 999999999999))) {
      return Future.value(
        const Error(ServerFailure(message: AppStrings.movementInvalid)),
      );
    }
    return _repository.saveMovement(params);
  }
}
