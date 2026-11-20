import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:ma7aly_app/core/errors/failures.dart';

import '../utils/app_strings.dart';
import 'exceptions.dart';

/// A mixin that provides exception handling for local storage operations in a repository.
mixin RepositoryLocalStorageExceptionMixin on Object {
  Future<Result<S, Failure>> localStorageExceptionHandler<S>(
    FutureOr<S> computation, {
    String unknownMessage = AppStrings.somethingWentWrong,
  }) async {
    try {
      final result = await computation;
      return Success(result);
    } on CacheException catch (error) {
      return Error(
        CachedFailure(message: error.message ?? unknownMessage),
      );
    } catch (e) {
      return Error(
        CachedFailure(
          message: unknownMessage.tr(),
        ),
      );
    }
  }
}
