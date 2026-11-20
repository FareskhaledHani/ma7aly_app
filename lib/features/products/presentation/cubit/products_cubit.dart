import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/customer_input.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'products_state.dart';

class ProductPageException implements Exception {
  const ProductPageException(this.failure);
  final Failure failure;
}

class ProductPageKey {
  const ProductPageKey({this.name, this.id});
  final String? name;
  final String? id;
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._getProducts) : super(const ProductsState()) {
    paging = PagingController(
      getNextPageKey: (_) => _hasMore ? _next : null,
      fetchPage: _fetch,
    );
  }
  final GetProductsUseCase _getProducts;
  late final PagingController<ProductPageKey, ProductEntity> paging;
  ProductPageKey _next = const ProductPageKey();
  bool _hasMore = true;
  int _generation = 0;
  Timer? _debounce;
  Future<List<ProductEntity>> _fetch(ProductPageKey key) async {
    final generation = _generation;
    final result = await _getProducts(
      GetProductsParams(
        query: state.query,
        filter: state.filter,
        afterName: key.name,
        afterId: key.id,
      ),
    );
    return result.when((items) {
      if (!isClosed && generation == _generation) {
        _hasMore = items.length == 20;
        if (items.isNotEmpty) {
          _next = ProductPageKey(
            name: CustomerInput.nameKey(items.last.name),
            id: items.last.id,
          );
        }
      }
      return items;
    }, (f) => throw ProductPageException(f));
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      emit(state.copyWith(query: query.trim()));
      refresh();
    });
  }

  void filter(ProductFilter value) {
    if (state.filter == value) return;
    emit(state.copyWith(filter: value));
    refresh();
  }

  void refresh() {
    _generation++;
    _hasMore = true;
    _next = const ProductPageKey();
    paging.refresh();
  }

  @override
  Future<void> close() {
    _generation++;
    _debounce?.cancel();
    paging.dispose();
    return super.close();
  }
}
