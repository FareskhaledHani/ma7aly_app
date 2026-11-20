import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/get_products_usecase.dart';
part 'products_state.freezed.dart';

@freezed
abstract class ProductsState with _$ProductsState {
  const factory ProductsState({
    @Default('') String query,
    @Default(ProductFilter.all) ProductFilter filter,
  }) = _ProductsState;
}
