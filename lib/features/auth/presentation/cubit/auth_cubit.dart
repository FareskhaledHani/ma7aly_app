import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._signIn, this._register) : super(const AuthState.initial());
  final SignInUseCase _signIn;
  final RegisterUseCase _register;

  Future<void> signIn(String email, String password) async {
    if (state is AuthLoading) return;
    emit(const AuthState.loading());
    final result = await _signIn(
      SignInParams(email: email, password: password),
    );
    if (isClosed) return;
    result.when(
      (account) => emit(AuthState.success(account)),
      (failure) => emit(AuthState.failure(failure.message)),
    );
  }

  Future<void> register(RegisterParams params) async {
    if (state is AuthLoading) return;
    emit(const AuthState.loading());
    final result = await _register(params);
    if (isClosed) return;
    result.when(
      (account) => emit(AuthState.success(account)),
      (failure) => emit(AuthState.failure(failure.message)),
    );
  }
}
