import 'dart:developer';

import 'package:egovisionapp/module/animated_splash/repository/app_setting_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_setting_state.dart';

class AppSettingCubit extends Cubit<AppSettingState> {
  final _className = 'AppSettingCubit';
  final AppSettingRepository _appSettingRepository;

  AppSettingCubit(AppSettingRepository appSettingRepository)
      : _appSettingRepository = appSettingRepository,
        super(const AppSettingStateInitial()) {
    init();
  }

  bool get isOnBoardingShown =>
      _appSettingRepository.checkOnBoarding().fold((l) => false, (r) => true);

  Future<bool> cacheOnBoarding() async {
    final result = await _appSettingRepository.cacheOnBoarding();

    return result.fold((l) => false, (success) => success);
  }

  void init() {
    emit(const AppSettingStateInitial());

    String? data;

    Future.delayed(const Duration(seconds: 5),() {
      data = 'Loaded';
      emit(AppSettingStateLoaded(data.toString()));
    });
  }

}
