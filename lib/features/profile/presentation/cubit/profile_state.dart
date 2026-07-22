part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, loggedOut, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.failureKey,
  });

  final ProfileStatus status;
  final UserEntity? user;
  final String? failureKey;

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    String? failureKey,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      failureKey: failureKey,
    );
  }

  @override
  List<Object?> get props => [status, user, failureKey];
}
