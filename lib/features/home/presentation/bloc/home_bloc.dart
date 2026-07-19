import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../product/domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeData, this._toggleFavorite)
      : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeFavoriteToggled>(_onFavoriteToggled);
  }

  final GetHomeDataUseCase _getHomeData;
  final ToggleFavoriteUseCase _toggleFavorite;

  Future<void> _load(Emitter<HomeState> emit, {required bool showLoader}) async {
    if (showLoader) emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeData(const NoParams());
    result.match(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, failureKey: failure.l10nKey),
      ),
      (data) => emit(state.copyWith(status: HomeStatus.loaded, data: data)),
    );
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) =>
      _load(emit, showLoader: true);

  Future<void> _onRefreshed(HomeRefreshed event, Emitter<HomeState> emit) =>
      _load(emit, showLoader: false);

  Future<void> _onFavoriteToggled(
    HomeFavoriteToggled event,
    Emitter<HomeState> emit,
  ) async {
    final data = state.data;
    if (data == null) return;
    final result = await _toggleFavorite(event.productId);
    result.match(
      (_) {},
      (isNowFavorite) {
        final favIds = <String>{
          for (final p in data.featured
              .followedBy(data.flashSale)
              .followedBy(data.newArrivals)
              .followedBy(data.bestSellers))
            if (p.isFavorite) p.id,
        };
        if (isNowFavorite) {
          favIds.add(event.productId);
        } else {
          favIds.remove(event.productId);
        }
        emit(state.copyWith(
          status: HomeStatus.loaded,
          data: data.withFavorites(favIds),
        ));
      },
    );
  }
}
