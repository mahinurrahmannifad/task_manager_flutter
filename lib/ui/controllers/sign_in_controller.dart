import 'package:get/get.dart';
import 'package:task_manager_flutter/data/services/network_caller.dart';
import 'package:task_manager_flutter/data/utils/urls.dart';

import '../../data/models/user_model.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{
  bool _inProgress= false;
  bool get inProgress=> _inProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess=false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.loginUrl, body: requestBody);
    _inProgress=false;
    update();

    if (response.isSuccess) {
      String token = response.responseData!['token'];
      UserModel userModel = UserModel.fromJson(response.responseData!['data']);
      await AuthController.saveUserData(token, userModel);

      isSuccess=true;
      _errorMessage=null;

    } else {
      if (response.statusCode == 401) {
        _errorMessage= 'Username or Password is incorrect';
      } else {
       _errorMessage= response.errorMessage;
      }
    }
    _inProgress=false;
    update();
    return isSuccess;
  }
}