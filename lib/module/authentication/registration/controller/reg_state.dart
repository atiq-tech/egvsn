
part of 'reg_bloc.dart';

class RegModelState extends Equatable {
  final String customerId;
  final String email;
  // final String password;
  // final String passwordConfirmation;
  final RegState state;
  const RegModelState({
    this.customerId = '',
    this.email = '',
    // this.password = '',
    // this.passwordConfirmation = '',
    this.state = const RegStateInitial(),
  });

  RegModelState copyWith({
    String? customerId,
    String? email,
    // String? password,
    // String? passwordConfirmation,
    RegState? state,
  }) {
    return RegModelState(

      customerId: customerId ?? this.customerId,
      email: email ?? this.email,
      // password: password ?? this.password,
      // passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'customerId': customerId.toString()});
    result.addAll({'email': email.trim()});
    // result.addAll({'password': password});
    // result.addAll({'password_confirmation': passwordConfirmation});

    return result;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SignUpModelState(customerId: $customerId, email: $email, state: $state)';
  }

  @override
  List<Object> get props {
    return [
      customerId,
      email,
      // password,
      // passwordConfirmation,
      state,
    ];
  }
}

abstract class RegState extends Equatable {
  const RegState();

  @override
  List<Object> get props => [];
}

class RegStateInitial extends RegState {
  const RegStateInitial();
}

class RegStateLoading extends RegState {
  const RegStateLoading();
}

class RegStateLoaded extends RegState {
  const RegStateLoaded(this.msg, this.email, this.userId);
  final String msg;
  final String userId;
  final String email;
  @override
  List<Object> get props => [msg, email,userId];
}

class RegStateLoadedError extends RegState {
  final String errorMsg;
  const RegStateLoadedError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class RegStateFormError extends RegState {
  final String errorMsg;
  const RegStateFormError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class RegOtpError extends RegState {
  final String errorMsg;
  const RegOtpError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class RegOtpLoaded extends RegState {
  final String msg;
  const RegOtpLoaded(this.msg);

  @override
  List<Object> get props => [msg];
}
