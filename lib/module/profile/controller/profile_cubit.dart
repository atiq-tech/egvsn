import 'dart:io';

import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/authentication/login/model/user_login_model.dart';
import 'package:egovisionapp/module/authentication/login/model/user_login_response_model.dart';
import 'package:egovisionapp/module/authentication/repository/auth_repository.dart';
import 'package:egovisionapp/module/main/main_controller.dart';
import 'package:egovisionapp/module/profile/repository/profile_repo.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileScreenCubit extends Cubit<ProfileControllerState> {
  ProfileScreenCubit(
      this.profileRepository, this.authRepository, this.loginBloc)
      : super(ProfileControllerLoading());

  ProfileRepository profileRepository;
  AuthRepository authRepository;
  final LoginBloc loginBloc;

  bool isPassLoading = false;
  bool isImgLoading = false;
  bool isPasswordBtnClk = false;

  final _homeController = MainController();

  String images = '';

  var currentPassCtrl = TextEditingController();
  var newPassCtrl = TextEditingController();
  var confirmPassCtrl = TextEditingController();

  Future<void> changePassword(context, currentPass, newPass) async {
    // emit(const OrderDetailsControllerLoading());

    var userId = loginBloc.userInfo?.user?.id;

    final result = await profileRepository.changePassword(
        userId ?? '', currentPass, newPass);

    result.fold(
      (failure) {
        emit(ProfileControllerError(errorMessage: failure.message));
        Utils.errorSnackBar(context, failure.message);
      },
      (data) {
        currentPassCtrl.text = '';
        newPassCtrl.text = '';
        confirmPassCtrl.text = '';
        emit(ProfileControllerLoaded(msg: data));
        Utils.showSnackBar(context, data);
        isPasswordBtnClk = false;
        _homeController.naveListener.sink.add(0);
      },
    );
  }

  Future<void> imageUpload(context, File image) async {
    images = image.path;

    var userId = loginBloc.userInfo?.user?.id;

    final result = await profileRepository.imageUpload(userId ?? '', image);

    result.fold(
      (failure) {
        emit(ProfileControllerError(errorMessage: failure.message));
        Utils.errorSnackBar(context, failure.message);
      },
      (data) {
        images = data;
        // print("Image is ${images}");
        loginBloc.add(UpdateProfileEvent(getUser()));
        // authRepository.saveCashedUserInfo(getUser());
        emit(ProfileControllerLoaded(msg: "success"));
        Utils.showSnackBar(context, "success");
      },
    );
  }

  UserLoginResponseModel getUser() {
    return UserLoginResponseModel(
      user: getUserData(),
      success: loginBloc.userInfo!.success,
      due: loginBloc.userInfo!.due,
    );
  }

  UserLoginModel getUserData() {
    return UserLoginModel(
        id: loginBloc.userInfo!.user!.id,
        image: images,
        status: loginBloc.userInfo!.user!.status,
        name: loginBloc.userInfo!.user!.name,
        phone: loginBloc.userInfo!.user!.phone,
        address: loginBloc.userInfo!.user!.address,
        code: loginBloc.userInfo!.user!.code,
        branchId: loginBloc.userInfo!.user!.branchId,
        area: loginBloc.userInfo!.user!.area,
        customerAddress: loginBloc.userInfo!.user!.customerAddress,
        customerEmail: loginBloc.userInfo!.user!.customerEmail,
        customerMobile: loginBloc.userInfo!.user!.customerMobile,
        customerSlNo: loginBloc.userInfo!.user!.customerSlNo,
        officerName: loginBloc.userInfo!.user!.officerName,
        organizationName: loginBloc.userInfo!.user!.organizationName,
        ownerName: loginBloc.userInfo!.user!.ownerName,
        password: loginBloc.userInfo!.user!.password);
  }
}
