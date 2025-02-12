import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_flutter/data/models/user_model.dart';

class AuthController extends GetxController {
  static const String _tokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String? accessToken;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  Future<void> saveData(String token, UserModel userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(_tokenKey, token); // Fixed space issue
    accessToken = token;

    await sharedPreferences.setString(_userDataKey, jsonEncode(userData.toJson()));
    userModel.value = userData;
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString(_tokenKey);
    String? userDataJson = sharedPreferences.getString(_userDataKey);

    if (token != null && userDataJson != null) {
      accessToken = token;
      userModel.value = UserModel.fromJson(jsonDecode(userDataJson));
    }
  }

  Future<bool> userLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_tokenKey);

    if (token != null) {
      await getUserData();
      return true;
    }
    return false;
  }

  Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userDataKey);

    accessToken = null;
    userModel.value = null;
  }
}
