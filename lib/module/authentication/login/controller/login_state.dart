part of 'login_bloc.dart';

class LoginModelState extends Equatable {
  final String userID;
  final String password;
  final LoginState state;
  const LoginModelState({
    this.userID = '',
    this.password = '',
    this.state = const LoginStateInitial(),
  });

  LoginModelState copyWith({
    String? userID,
    String? password,
    LoginState? state,
  }) {
    return LoginModelState(
      userID: userID ?? this.userID,
      password: password ?? this.password,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'phone': userID.trim()});
    result.addAll({'password': password});
    // result.addAll({'state': state});

    return result;
  }

  factory LoginModelState.fromMap(Map<String, dynamic> map) {
    return LoginModelState(
      userID: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModelState.fromJson(String source) =>
      LoginModelState.fromMap(json.decode(source));

  @override
  String toString() =>
      'LoginModelState(phone: $userID, password: $password, state: $state)';

  @override
  List<Object> get props => [userID, password, state];
}

abstract class LoginState extends Equatable {
  const LoginState();

   @override
  List<Object> get props => [];

 
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial();
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading();
}

class LoginStateGoogleLoading extends LoginState {
  const LoginStateGoogleLoading();
}

class LoginStateLogOutLoading extends LoginState {
  const LoginStateLogOutLoading();
}

class LoginStateLoaded extends LoginState {
  final UserLoginResponseModel user;
  const LoginStateLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class LoginStateUpdatedProfile extends LoginState {
  final UserLoginResponseModel user;

  const LoginStateUpdatedProfile(this.user);

  @override
  List<Object> get props => [user];
}

class LoginStateError extends LoginState {
  final String errorMsg;


  const LoginStateError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class LoginStateSignOutError extends LoginState {
  final String errorMsg;
  final int statusCode;

  const LoginStateSignOutError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}

class AccountActivateSuccess extends LoginState {
  final String msg;

  const AccountActivateSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendAccountCodeSuccess extends LoginState {
  final String msg;

  const SendAccountCodeSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

class LoginStateLogOut extends LoginState {
  final String msg;
  final int statusCode;

  const LoginStateLogOut(this.msg, this.statusCode);

  @override
  List<Object> get props => [msg, statusCode];
}
