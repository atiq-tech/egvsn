
import 'dart:convert';

import 'package:egovisionapp/core/error/failures.dart';
import 'package:egovisionapp/module/authentication/login/model/user_login_response_model.dart';
import 'package:egovisionapp/module/authentication/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginModelState> {
  final AuthRepository _authRepository;
  // final ProfileRepository _profileRepository;
  final formKey = GlobalKey<FormState>();

  UserLoginResponseModel? _user;

  bool get isLoggedIn => _user != null && _user!.user!.id.isNotEmpty;

  UserLoginResponseModel? get userInfo => _user;
  set user(UserLoginResponseModel userData) => _user = userData;

  LoginBloc({
    required AuthRepository authRepository,
    // required ProfileRepository profileRepository,
  })  : _authRepository = authRepository,
        // _profileRepository = profileRepository,
        super(const LoginModelState()) {
    on<LoginEventUserId>((event, emit) {
      emit(state.copyWith(userID: event.userId));
    });
    on<LoginEventPassword>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<LoginEventSubmit>(_submitLoginForm);
    on<LoginEventLogout>(_logOut);
    on<LoginEventCheckProfile>(_getUserInfo);
    on<UpdateProfileEvent>(_updateProfile);

    /// set user data if usre already login
    final result = _authRepository.getCashedUserInfo();

    result.fold(
      (l) => _user = null,
      (r) {
        user = r;
      },
    );
  }
  Future<void> _getUserInfo(
    LoginEventCheckProfile event,
    Emitter<LoginModelState> emit,
  ) async {
    final result = _authRepository.getCashedUserInfo();

    result.fold(
      (l) => _user = null,
      (r) {
        user = r;
        emit(state.copyWith(state: LoginStateLoaded(r)));
      },
    );

    ///load user info if user longed in and update user on bloc state
    // if (isLoggedIn) {
    //   final updateProfile = await _profileRepository.userProfile(userInfo!.user.id);
    //
    //   updateProfile.fold(
    //     (failure) {
    //       if (failure.statusCode == 401) {
    //         final currentState = LoginStateLogOut(
    //             'Session expired, Signin again', failure.statusCode);
    //         emit(state.copyWith(state: currentState));
    //       } else {
    //         final currentState =
    //             LoginStateError(failure.message, failure.statusCode);
    //         emit(state.copyWith(state: currentState));
    //       }
    //     },
    //   );
    // } else {
    //   _user = null;
    //   const currentState = LoginStateInitial();
    //   emit(state.copyWith(state: currentState));
    // }
  }

  Future<void> _submitLoginForm(
    LoginEventSubmit event,
    Emitter<LoginModelState> emit,
  ) async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(state: const LoginStateLoading()));
    final bodyData = state.toMap();

    final result = await _authRepository.login(bodyData);

    result.fold(
      (Failure failure) {
        final error = LoginStateError(failure.message);
        emit(state.copyWith(state: error));
      },
      (user) {
        print("uuuuuuuuuuuuuuuuu $user uuuuuuuuuuuuuuuuuu");
        final loadedData = LoginStateLoaded(user);
        _user = user;
        emit(state.copyWith(state: loadedData));

        emit(state.copyWith(
          userID: '',
          password: '',
          state: const LoginStateInitial(),
        ));
      },
    );
  }


  Future<void> _logOut(
      LoginEventLogout event,
      Emitter<LoginModelState> emit,
      ) async {
    emit(state.copyWith(state: const LoginStateLogOutLoading()));

    final result = await _authRepository.logOut(userInfo!.user!.id);

    result.fold(
          (Failure failure) {
        if (failure.statusCode == 500) {
          const loadedData = LoginStateLogOut('logout success', 200);
          emit(state.copyWith(state: loadedData));
        } else {
          final error =
          LoginStateSignOutError(failure.message, failure.statusCode);
          emit(state.copyWith(state: error));
        }
      },
          (String success) {
        _user = null;
        final loadedData = LoginStateLogOut(success, 200);
        emit(state.copyWith(state: loadedData));
      },
    );
  }

  Future<void> _updateProfile(
      UpdateProfileEvent event,
      Emitter<LoginModelState> emit,
      ) async {
    final loadedData = LoginStateLoaded(event.user);
    _user = event.user;
    emit(state.copyWith(state: loadedData));
  }
}
