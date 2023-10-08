import 'dart:convert';

import 'package:egovisionapp/module/authentication/login/model/user_login_model.dart';
import 'package:equatable/equatable.dart';



class UserLoginResponseModel extends Equatable {
  UserLoginModel? user;
  final String success;
  final String due;
  UserLoginResponseModel({
    this.user,
    required this.success,
    required this.due,
  });

  UserLoginResponseModel copyWith({
    UserLoginModel? user,
    String? success,
    String? due,
  }) {
    return UserLoginResponseModel(
      user: user ?? this.user,
      success: success ?? this.success,
      due: due ?? this.due,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'user': user?.toMap()});
    result.addAll({'success': success});
    result.addAll({'due': due});

    return result;
  }

  factory UserLoginResponseModel.fromMap(Map<String, dynamic> map) {
    return UserLoginResponseModel(
      user: map['user'] == null ? null : UserLoginModel.fromMap(map['user']),
      success: map['success'] ?? '',
      due: map['due'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoginResponseModel.fromJson(String source) =>
      UserLoginResponseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserLoginResponseModel(user: $user, success: $success, due: $due,';
  }

  @override
  List<Object?> get props => [
    user,
    success,
    due,
  ];
}
