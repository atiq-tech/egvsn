import 'dart:convert';
import 'dart:developer';
import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/module/authentication/login/model/user_login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/k_strings.dart';

abstract class LocalDataSource {
  /// Gets the cached [UserLoginResponseModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.

  // Future<bool> cacheUserProfile(UserProfileModel userProfileModel);
  Future<bool> clearUserProfile();
  bool checkOnBoarding();
  Future<bool> cacheOnBoarding();
  Future<bool> cacheUserResponse(UserLoginResponseModel userLoginResponseModel);
  // Future<bool> cacheUserProfile(UserProfileModel userProfileModel);
  // Future<bool> clearUserProfile();
  UserLoginResponseModel getUserResponseModel();


  // //.............. language ..............
  // Future<bool> cacheLanguages(List<LanguageModel> languages);
  // bool checkLanguage();
  // Future<bool> cacheLanguage();
  //
  // List<LanguageModel> getCachedLanguages();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  // @override
  // Future<bool> cacheUserProfile(UserProfileModel userProfileModel) {
  //   final user = getUserResponseModel();
  //   user.user != userProfileModel;
  //   return cacheUserResponse(user);
  // }

  @override
  UserLoginResponseModel getUserResponseModel() {
    final jsonString =
    sharedPreferences.getString(KStrings.cachedUserResponseKey);
    if (jsonString != null) {
      return UserLoginResponseModel.fromJson(jsonString);
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

  @override
  Future<bool> clearUserProfile() {
    return sharedPreferences.remove(KStrings.cachedUserResponseKey);
  }

  @override
  bool checkOnBoarding() {
    final jsonString = sharedPreferences.getBool(KStrings.cacheOnBoardingKey);
    if (jsonString != null) {
      return true;
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

  @override
  Future<bool> cacheOnBoarding() {
    return sharedPreferences.setBool(KStrings.cacheOnBoardingKey, true);
  }

  @override
  Future<bool> cacheUserResponse(
      UserLoginResponseModel userLoginResponseModel) {
    return sharedPreferences.setString(
      KStrings.cachedUserResponseKey,
      userLoginResponseModel.toJson(),
    );
  }

}
