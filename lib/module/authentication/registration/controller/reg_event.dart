part of 'reg_bloc.dart';

abstract class RegEvent extends Equatable {
  const RegEvent();

  @override
  List<Object> get props => [];
}

class RegEventUserId extends RegEvent {
  final String userId;

  const RegEventUserId(this.userId);
  @override
  List<Object> get props => [userId];
}

class RegEventEmail extends RegEvent {
  final String email;

  const RegEventEmail(this.email);
  @override
  List<Object> get props => [email];
}

// class SignUpEventUserName extends SignUpEvent {
//   final String username;
//
//   const SignUpEventUserName(this.username);
//   @override
//   List<Object> get props => [username];
// }

class RegEventPassword extends RegEvent {
  final String password;

  const RegEventPassword(this.password);
  @override
  List<Object> get props => [password];
}

class RegEventPasswordConfirm extends RegEvent {
  final String passwordConfirm;

  const RegEventPasswordConfirm(this.passwordConfirm);
  @override
  List<Object> get props => [passwordConfirm];
}

// class SignUpEventAgree extends SignUpEvent {
//   final int agree;
//
//   const SignUpEventAgree(this.agree);
//   @override
//   List<Object> get props => [agree];
// }

class RegEventSubmit extends RegEvent {}
