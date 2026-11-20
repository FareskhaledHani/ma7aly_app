import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../datasources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._remote);
  final ProductsRemoteDataSource _remote;
  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on FirebaseException catch (error) {
      return Error(
        ServerFailure(
          message: switch (error.code) {
            'unavailable' ||
            'network-request-failed' => AppStrings.noInternetConnection,
            'already-exists' => AppStrings.productAlreadySaved,
            'permission-denied' ||
            'unauthenticated' ||
            'requires-recent-login' => AppStrings.customersAccessDenied,
            _ => AppStrings.somethingWentWrong,
          },
        ),
      );
    } catch (_) {
      return const Error(ServerFailure(message: AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Result<List<ProductEntity>, Failure>> getProducts(
    GetProductsParams params,
  ) => _guard(() => _remote.getProducts(params));
  @override
  Future<Result<void, Failure>> addProduct(ProductEntity product) =>
      _guard(() => _remote.addProduct(product));
}
