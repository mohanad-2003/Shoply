part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.failureKey,
  });

  final HomeStatus status;
  final HomeDataEntity? data;
  final String? failureKey;

  HomeState copyWith({
    HomeStatus? status,
    HomeDataEntity? data,
    String? failureKey,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      failureKey: failureKey,
    );
  }

  @override
  List<Object?> get props => [status, data, failureKey];
}
