import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain/entities/customer_movement_entity.dart';
import '../../domain/usecases/get_customer_account_usecase.dart';
import 'customer_account_state.dart';

class CustomerAccountCubit extends Cubit<CustomerAccountState> {
  CustomerAccountCubit(this._getAccount)
    : super(const CustomerAccountState.initial()) {
    paging = PagingController<int, CustomerMovementEntity>(
      getNextPageKey: (page) =>
          page.lastPageIsEmpty ? null : page.nextIntPageKey,
      fetchPage: (key) async {
        final current = state;
        if (current is! CustomerAccountSuccess) return [];
        final items = current.account.movements;
        final start = (key - 1) * 20;
        return start >= items.length
            ? []
            : items.sublist(start, math.min(start + 20, items.length));
      },
    );
  }
  final GetCustomerAccountUseCase _getAccount;
  late final PagingController<int, CustomerMovementEntity> paging;
  int _generation = 0;
  Future<void> load(String customerId) async {
    final generation = ++_generation;
    emit(const CustomerAccountState.loading());
    final result = await _getAccount(CustomerAccountParams(customerId));
    if (isClosed || generation != _generation) return;
    result.when((account) {
      emit(CustomerAccountState.success(account));
      paging.refresh();
    }, (failure) => emit(CustomerAccountState.failure(failure.message)));
  }

  @override
  Future<void> close() {
    _generation++;
    paging.dispose();
    return super.close();
  }
}
