import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class RecoverResetPasswordController extends GetxController{
  late String _errorMessage;
  String get errorMessage => _errorMessage;

  /// Sends the new password along with the OTP to reset the password.
  Future<bool> postResetPassword(
      {required String email,
        required String otp,
        required String password}) async {
    bool resetPasswordIsSuccess = false;
    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.recoverResetPassUrl, body: requestBody);

    debugPrint('email=> $email');
    debugPrint('OTP=> $otp');

    if (response.responseData?['status'] == 'success') {
      _errorMessage='Password changed successfully.';
      return resetPasswordIsSuccess=true;
    } else {
      _errorMessage= 'Request failed. Please try again!';
    }
    return resetPasswordIsSuccess;
  }


}
