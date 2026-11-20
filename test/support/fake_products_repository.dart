import 'package:multiple_result/multiple_result.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/core/helpers/customer_input.dart';
import 'package:ma7aly_app/features/products/domain/entities/product_entity.dart';
import 'package:ma7aly_app/features/products/domain/repositories/products_repository.dart';
import 'package:ma7aly_app/features/products/domain/usecases/get_products_usecase.dart';

class FakeProductsRepository implements ProductsRepository {
  final items = <ProductEntity>[];
  int addCalls = 0;
  Future<Result<void, Failure>>? addResponse;
  Future<Result<List<ProductEntity>, Failure>> Function(GetProductsParams)?
  pageResponse;
  @override
  Future<Result<void, Failure>> addProduct(ProductEntity product) async {
    addCalls++;
    if (addResponse != null) return addResponse!;
    items.add(product);
    return const Success(null);
  }

  @override
  Future<Result<List<ProductEntity>, Failure>> getProducts(
    GetProductsParams params,
  ) async {
    if (pageResponse != null) return pageResponse!(params);
    final result =
        items
            .where(
              (p) =>
                  CustomerInput.nameKey(p.name)
                      .startsWith(CustomerInput.nameKey(params.query)) &&
                  (params.filter == ProductFilter.all ||
                      params.filter == ProductFilter.pricesOnly &&
                          !p.trackInventory ||
                      params.filter == ProductFilter.lowStock &&
                          p.trackInventory &&
                          p.stockMilli <= p.lowStockMilli),
            )
            .toList()
          ..sort(
            (a, b) =>
                CustomerInput.nameKey(a.name)
                    .compareTo(CustomerInput.nameKey(b.name)),
          );
    final index = params.afterId == null
        ? 0
        : result.indexWhere((p) => p.id == params.afterId) + 1;
    return Success(result.skip(index).take(params.pageSize).toList());
  }
}
