import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/customers_page_entity.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import 'customers_state.dart';
import '../../../../core/errors/failures.dart';

class CustomersPageException implements Exception {
  const CustomersPageException(this.failure);
  final Failure failure;
}

class CustomerPageKey {
  const CustomerPageKey(this.cursor);
  final CustomerCursor? cursor;
}

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._getCustomers, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(const CustomersState()) {
    paging = PagingController(
      getNextPageKey: (_) => _hasMore ? _nextKey : null,
      fetchPage: _fetch,
    );
  }
  final GetCustomersUseCase _getCustomers;
  final DateTime Function() _clock;
  late final PagingController<CustomerPageKey, CustomerEntity> paging;
  CustomerPageKey _nextKey = const CustomerPageKey(null);
  bool _hasMore = true;
  int _generation = 0;
  Timer? _debounce;

  Future<List<CustomerEntity>> _fetch(CustomerPageKey key) async {
    final generation = _generation;
    final result = await _getCustomers(
      GetCustomersParams(
        query: state.query,
        filter: state.filter,
        cursor: key.cursor,
        today: _clock(),
      ),
    );
    return result.when((page) {
      if (!isClosed && generation == _generation) {
        _hasMore = page.hasMore;
        _nextKey = CustomerPageKey(page.nextCursor);
        if (page.totalCount != null) {
          emit(state.copyWith(totalCount: page.totalCount!));
        }
      }
      return page.items;
    }, (failure) => throw CustomersPageException(failure));
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      emit(state.copyWith(query: query));
      refresh();
    });
  }

  void filter(CustomerFilter filter) {
    if (state.filter == filter) return;
    emit(state.copyWith(filter: filter));
    refresh();
  }

  void refresh() {
    _generation++;
    _hasMore = true;
    _nextKey = const CustomerPageKey(null);
    paging.refresh();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _generation++;
    paging.dispose();
    return super.close();
  }
}
