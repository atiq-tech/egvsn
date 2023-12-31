part of 'app_setting_cubit.dart';

abstract class AppSettingState extends Equatable {
  const AppSettingState();

  @override
  List<Object> get props => [];
}

class AppSettingStateInitial extends AppSettingState {
  const AppSettingStateInitial();
}

class AppSettingStateLoading extends AppSettingState {
  const AppSettingStateLoading();
}

class AppSettingStateError extends AppSettingState {
  final String meg;
  final int statusCode;
  const AppSettingStateError(this.meg, this.statusCode);
}

class AppSettingStateLoaded extends AppSettingState {
  final String value;
  const AppSettingStateLoaded(this.value);
}
