import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this._add) : super(const AddProductState.initial());
  final AddProductUseCase _add;
  Future<void> save(ProductEntity product) async {
    if (state is ProductLoading || state is ProductSuccess) return;
    emit(const AddProductState.loading());
    final result = await _add(product);
    if (isClosed) return;
    result.when(
      (_) => emit(const AddProductState.success()),
      (f) => emit(AddProductState.failure(f.message)),
    );
  }
}
