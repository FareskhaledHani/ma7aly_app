import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/async_status.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../domain/entities/shop_settings_entity.dart';
part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(AsyncStatus.initial) AsyncStatus status,
    ShopSettingsEntity? settings,
    @Default(false) bool busy,
    String? message,
    @Default(false) bool signedOut,
    @Default(0) int event,
    List<CustomerEntity>? report,
  }) = _SettingsState;
}
