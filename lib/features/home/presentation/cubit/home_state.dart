import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/async_status.dart';
import '../../domain/entities/home_overview_entity.dart';
part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(AsyncStatus.initial) AsyncStatus status,
    HomeOverviewEntity? overview,
    String? errorMessage,
  }) = _HomeState;
}
