import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/async_status.dart';
import '../../../../core/params/no_params.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../auth/domain/usecases/reset_password_usecase.dart';
import '../../domain/entities/shop_settings_entity.dart';
import '../../domain/usecases/load_settings_usecase.dart';
import '../../domain/usecases/save_settings_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/export_accounts_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._load,
    this._save,
    this._signOut,
    this._export,
    this._reset,
  ) : super(const SettingsState());
  final LoadSettingsUseCase _load;
  final SaveSettingsUseCase _save;
  final SignOutUseCase _signOut;
  final ExportAccountsUseCase _export;
  final ResetPasswordUseCase _reset;
  Future<void> load() async {
    emit(state.copyWith(status: AsyncStatus.loading, report: null));
    final result = await _load(noParams);
    if (isClosed) return;
    result.when(
      (s) => emit(state.copyWith(status: AsyncStatus.success, settings: s)),
      (f) =>
          emit(state.copyWith(status: AsyncStatus.failure, message: f.message)),
    );
  }

  Future<void> save(ShopSettingsEntity value) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true, message: null, report: null));
    final result = await _save(value);
    if (isClosed) return;
    result.when(
      (_) => emit(
        state.copyWith(
          busy: false,
          settings: value,
          message: AppStrings.settingsSaved,
          event: state.event + 1,
        ),
      ),
      (f) => emit(
        state.copyWith(busy: false, message: f.message, event: state.event + 1),
      ),
    );
  }

  Future<void> signOut() async {
    if (state.busy) return;
    emit(state.copyWith(busy: true, report: null));
    final result = await _signOut(noParams);
    if (isClosed) return;
    result.when(
      (_) => emit(state.copyWith(busy: false, signedOut: true)),
      (f) => emit(
        state.copyWith(busy: false, message: f.message, event: state.event + 1),
      ),
    );
  }

  Future<void> export() async {
    if (state.busy) return;
    emit(state.copyWith(busy: true, report: null));
    final result = await _export(noParams);
    if (isClosed) return;
    result.when(
      (rows) => emit(
        state.copyWith(busy: false, report: rows, event: state.event + 1),
      ),
      (f) => emit(
        state.copyWith(busy: false, message: f.message, event: state.event + 1),
      ),
    );
  }

  Future<void> resetPassword() async {
    final email = state.settings?.email;
    if (state.busy || email == null || email.isEmpty) return;
    emit(state.copyWith(busy: true, report: null));
    final result = await _reset(ResetPasswordParams(email));
    if (isClosed) return;
    result.when(
      (_) => emit(
        state.copyWith(
          busy: false,
          message: AppStrings.passwordResetSent,
          event: state.event + 1,
        ),
      ),
      (f) => emit(
        state.copyWith(busy: false, message: f.message, event: state.event + 1),
      ),
    );
  }
}
