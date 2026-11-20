import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../usecases/get_products_usecase.dart';

abstract class ProductsRepository {
  Future<Result<List<ProductEntity>, Failure>> getProducts(
    GetProductsParams params,
  );
  Future<Result<void, Failure>> addProduct(ProductEntity product);
}
