import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/reset_password_usecase.dart';
import 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._resetPassword)
    : super(const PasswordResetState.initial());
  final ResetPasswordUseCase _resetPassword;

  Future<void> resetPassword(String email) async {
    if (state is PasswordResetLoading) return;
    emit(const PasswordResetState.loading());
    final result = await _resetPassword(ResetPasswordParams(email));
    if (isClosed) return;
    result.when(
      (_) => emit(const PasswordResetState.success()),
      (failure) => emit(PasswordResetState.failure(failure.message)),
    );
  }
}
