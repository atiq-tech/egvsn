import 'package:egovisionapp/core/error/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';


import '../../repository/auth_repository.dart';
part 'reg_event.dart';
part 'reg_state.dart';

class RegBloc extends Bloc<RegEvent, RegModelState> {
  final AuthRepository repository;

  final formKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  bool isOtpSend = false;

  final userIdController = TextEditingController();
  final emailPhoneController = TextEditingController();
  final codeController = TextEditingController();
  final passController = TextEditingController();
  final conPassController = TextEditingController();

  RegBloc(this.repository) : super(const RegModelState()) {
    on<RegEventUserId>((event, emit) {
      emit(state.copyWith(customerId: event.userId));
    });
    on<RegEventEmail>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    // on<SignUpEventUserName>((event, emit) {
    //   emit(state.copyWith(username: event.username));
    // });
    // on<RegEventPassword>((event, emit) {
    //   emit(state.copyWith(password: event.password));
    // });
    // on<RegEventPasswordConfirm>((event, emit) {
    //   emit(state.copyWith(passwordConfirmation: event.passwordConfirm));
    // });
    // on<SignUpEventAgree>((event, emit) {
    //   emit(state.copyWith(agree: event.agree));
    // });
    on<RegEventSubmit>(_submitForm);
  }
  void _submitForm(
      RegEventSubmit event, Emitter<RegModelState> emit) async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(state: const RegStateLoading()));
    final bodyData = state.toMap();

    final result = await repository.signUp(bodyData);

    result.fold(
          (Failure failure) {
        final error = RegStateLoadedError(failure.message);
        emit(state.copyWith(state: error));
        // Utils.errorSnackBar(context, failure.message);
      },
          (success) {
        emit(state.copyWith(state: RegStateLoaded(success, emailPhoneController.text, userIdController.text)));
      },
    );
  }

  void register(String otp, String pass) async {

    emit(state.copyWith(state: const RegStateLoading()));

    final bodyData = {
      "otp": otp,
      "password": pass,
    };

    print('jhkagsdfhjukasf $bodyData');

    final result = await repository.otpVerify(bodyData);

    result.fold(
          (Failure failure) {
        final error = RegOtpError(failure.message);
        emit(state.copyWith(state: error));
      },
          (success) {
            codeController.text = '';
            passController.text = '';
            conPassController.text = '';
        emit(state.copyWith(state: RegOtpLoaded(success)));

      },
    );

  }

}
