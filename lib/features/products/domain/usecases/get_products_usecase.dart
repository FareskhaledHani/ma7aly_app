import 'package:equatable/equatable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

enum ProductFilter { all, lowStock, pricesOnly }

class GetProductsParams extends Equatable {
  const GetProductsParams({
    this.query = '',
    this.afterName,
    this.afterId,
    this.pageSize = 20,
    this.filter = ProductFilter.all,
  });
  final String query;
  final String? afterName;
  final String? afterId;
  final int pageSize;
  final ProductFilter filter;
  @override
  List<Object?> get props => [query, afterName, afterId, pageSize, filter];
}

class GetProductsUseCase
    extends UseCase<List<ProductEntity>, GetProductsParams> {
  GetProductsUseCase(this._repository);
  final ProductsRepository _repository;
  @override
  Future<Result<List<ProductEntity>, Failure>> call(GetProductsParams params) =>
      _repository.getProducts(params);
}
