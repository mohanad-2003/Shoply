part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

class HomeFavoriteToggled extends HomeEvent {
  const HomeFavoriteToggled(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}
