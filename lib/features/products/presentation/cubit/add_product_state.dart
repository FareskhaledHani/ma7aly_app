import 'package:freezed_annotation/freezed_annotation.dart';
part 'add_product_state.freezed.dart';

@freezed
sealed class AddProductState with _$AddProductState {
  const factory AddProductState.initial() = ProductInitial;
  const factory AddProductState.loading() = ProductLoading;
  const factory AddProductState.success() = ProductSuccess;
  const factory AddProductState.failure(String message) = ProductFailure;
}
