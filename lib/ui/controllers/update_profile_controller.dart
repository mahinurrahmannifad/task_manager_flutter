import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_flutter/data/models/user_model.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {

  bool _isDataProgress = false;
  bool get isDataProgress => _isDataProgress;
  AuthController authController = Get.put(AuthController());


  late String _errorMessage;
  String get errorMessage => _errorMessage;

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    XFile? image,
  }) async {
    bool isSuccess = false;

    _isDataProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      requestBody["photo"] = base64Encode(imageBytes);
    }


    if (password!.isNotEmpty) {
      requestBody["password"] = password;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
    );
    print("Request Body: $requestBody");

    _isDataProgress = false;
    update();


    if (response.isSuccess && response.responseData!.isNotEmpty) {
      try {
        final Map<String, dynamic> responseData = response.responseData?['data'] ?? {};

        if (responseData.isNotEmpty) {
          _errorMessage = 'Profile has been updated';

          UserModel updatedUserData = UserModel.fromJson({
            "email": authController.userModel.value?.email, // Retain the existing email
            "firstName": firstName, // Update the first name
            "lastName": lastName, // Update the last name
            "mobile": mobile, // Update the mobile number
            "photo": image != null
                ? base64Encode(await image.readAsBytes()) // Use the new photo if provided
                : authController.userModel.value?.photo, // Retain the existing photo if no new photo is provided
          });

          // Save the updated data to the `AuthController`
          await authController.saveData(AuthController.accessToken!, updatedUserData);

          isSuccess = true; // Mark the operation as successful
        } else {
          _errorMessage = 'No data returned from server.';
        }
      } catch (e) {
        _errorMessage= 'Unexpected response from server.'; // Handle unexpected server responses
      }
    } else {
      _errorMessage = 'Failed to update profile. Please try again.'; // Handle failed requests
    }
    return isSuccess;
  }
}