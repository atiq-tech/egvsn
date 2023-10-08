part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEventUserId extends LoginEvent {
  final String userId;
  const LoginEventUserId(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoginEventPassword extends LoginEvent {
  final String password;
  const LoginEventPassword(this.password);

  @override
  List<Object> get props => [password];
}

class LoginEventSubmit extends LoginEvent {
  const LoginEventSubmit();
}

class LoginWithGoogleEventSubmit extends LoginEvent {
  const LoginWithGoogleEventSubmit(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class LoginWithFacebookEventSubmit extends LoginEvent {
  const LoginWithFacebookEventSubmit(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class LoginEventLogout extends LoginEvent {
  const LoginEventLogout();
}

class LoginEventCheckProfile extends LoginEvent {
  const LoginEventCheckProfile();
}

class SentAccountActivateCodeSubmit extends LoginEvent {
  const SentAccountActivateCodeSubmit();
}

class AccountActivateCodeSubmit extends LoginEvent {
  const AccountActivateCodeSubmit(this.code);
  final String code;
  @override
  List<Object> get props => [code];
}

class UpdateProfileEvent extends LoginEvent {
  const UpdateProfileEvent(this.user);
  final UserLoginResponseModel user;

  @override
  List<Object> get props => [user];
}
