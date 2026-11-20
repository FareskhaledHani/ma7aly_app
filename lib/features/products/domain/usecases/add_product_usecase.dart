import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../../../../core/utils/app_strings.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class AddProductUseCase extends UseCase<void, ProductEntity> {
  AddProductUseCase(this._repository);
  final ProductsRepository _repository;
  @override
  Future<Result<void, Failure>> call(ProductEntity product) {
    if (!RegExp(r'^[A-Za-z0-9_-]{22}$').hasMatch(product.id) ||
        product.name.trim().isEmpty ||
        product.name.length > 100 ||
        product.unit.trim().isEmpty ||
        product.unit.length > 24 ||
        product.priceMinor < 0 ||
        product.priceMinor > 999999999999 ||
        (product.costMinor != null &&
            (product.costMinor! < 0 || product.costMinor! > 999999999999)) ||
        product.stockMilli < 0 ||
        product.stockMilli > 999999999 ||
        product.lowStockMilli < 0 ||
        product.lowStockMilli > 999999999 ||
        (product.extraUnit?.length ?? 0) > 100) {
      return Future.value(
        const Error(ServerFailure(message: AppStrings.productInvalid)),
      );
    }
    return _repository.addProduct(product);
  }
}
