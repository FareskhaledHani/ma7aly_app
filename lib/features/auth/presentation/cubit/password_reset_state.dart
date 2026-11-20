import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_reset_state.freezed.dart';

@freezed
sealed class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState.initial() = PasswordResetInitial;
  const factory PasswordResetState.loading() = PasswordResetLoading;
  const factory PasswordResetState.success() = PasswordResetSuccess;
  const factory PasswordResetState.failure(String message) =
      PasswordResetFailure;
}
