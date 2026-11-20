import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_customer_usecase.dart';
import 'add_customer_state.dart';

class AddCustomerCubit extends Cubit<AddCustomerState> {
  AddCustomerCubit(this._addCustomer) : super(const AddCustomerState.initial());
  final AddCustomerUseCase _addCustomer;
  Future<void> save(AddCustomerParams params) async {
    if (state is AddCustomerLoading || state is AddCustomerSuccess) return;
    emit(const AddCustomerState.loading());
    final result = await _addCustomer(params);
    if (isClosed) return;
    result.when(
      (id) => emit(AddCustomerState.success(id)),
      (failure) => emit(AddCustomerState.failure(failure.message)),
    );
  }
}
