part of 'profile_cubit.dart';

abstract class ProfileControllerState extends Equatable {
  const ProfileControllerState();

  @override
  List<Object> get props => [];
}

class ProfileControllerLoading extends ProfileControllerState {}

class ProfileControllerError extends ProfileControllerState {
  final String errorMessage;
  const ProfileControllerError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class ProfileControllerLoaded extends ProfileControllerState {
  final String msg;

  const ProfileControllerLoaded({required this.msg});

  @override
  List<Object> get props => [msg];
}
