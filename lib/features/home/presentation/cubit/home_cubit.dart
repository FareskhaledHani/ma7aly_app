import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/async_status.dart';
import '../../domain/usecases/get_home_overview_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getOverview, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(const HomeState());
  final GetHomeOverviewUseCase _getOverview;
  final DateTime Function() _clock;
  int _generation = 0;
  Future<void> load() async {
    final generation = ++_generation;
    emit(state.copyWith(status: AsyncStatus.loading, errorMessage: null));
    final result = await _getOverview(_clock());
    if (isClosed || generation != _generation) return;
    result.when(
      (overview) =>
          emit(HomeState(status: AsyncStatus.success, overview: overview)),
      (failure) => emit(
        HomeState(status: AsyncStatus.failure, errorMessage: failure.message),
      ),
    );
  }
}
