// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:task_manager_flutter/data/services/network_caller.dart';
// import 'package:task_manager_flutter/data/utils/urls.dart';
//
// import '../../data/models/user_model.dart';
// import 'auth_controller.dart';
//
// class SignInController extends GetxController{
//   bool _inProgress= false;
//   bool get inProgress=> _inProgress;
//   AuthController authController = Get.put(AuthController());
//
//   late String? _errorMessage;
//   String? get errorMessage=> _errorMessage;
//
//
//   Future<bool> signIn(String email, String password) async {
//     bool isSuccess=false;
//     _inProgress = true;
//     update();
//
//     Map<String, dynamic> requestBody = {
//       "email": email,
//       "password": password,
//     };
//
//     final NetworkResponse response =
//     await NetworkCaller.postRequest(url: Urls.loginUrl, body: requestBody);
//     _inProgress=false;
//     update();
//
//     if (response.isSuccess) {
//       if (response.responseData is String) {
//         try {
//           response.responseData= jsonDecode(response.responseData as String);
//         } catch (e) {
//           _errorMessage='Response not working.${e.toString()}';
//           return false;
//         }
//       }
//
//       String? token = response.responseData?['token'];
//       UserModel? userData = UserModel.fromJson(response.responseData?['data'] ?? {});
//
//       if (token != null) {
//         await authController.saveData(token, userData);
//         _errorMessage='Login Success';
//         isSuccess =true;
//       } else {
//         _errorMessage ='Email/Password Invalid.';
//       }
//     }
//     return isSuccess;
//   }
//
//
// }



import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.loginUrl, body: requestBody);
    if (response.isSuccess) {
      try {
        String token = response.responseData!['token'];
        UserModel userModel = UserModel.fromJson(response.responseData!['data']);

        await AuthController().saveData(token, userModel);

        isSuccess = true;
        _errorMessage = null;
      } catch (e) {
        _errorMessage = 'Error processing response: ${e.toString()}';
        isSuccess = false;
      }
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
