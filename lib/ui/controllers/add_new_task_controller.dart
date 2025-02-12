import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class AddNewTaskController extends GetxController{
  bool _addNewTaskInProgress = false;
  bool get addNewTaskInProgress=>_addNewTaskInProgress;
  late String _errorMessage;
  String get errorMessage => _errorMessage;

  Future<bool> addNewTaskItem({required String title, required String description}) async {
    bool addNewTaskItemIsSuccess =false;
    _addNewTaskInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New",
    };

    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);

    _addNewTaskInProgress = false;
    update();

    if (networkResponse.isSuccess) {
      _errorMessage= 'New Task Added';
      return addNewTaskItemIsSuccess = true;
    } else {
      debugPrint(networkResponse.errorMessage);
      debugPrint(networkResponse.statusCode.toString());
      _errorMessage= 'Added field';
    }
    return addNewTaskItemIsSuccess;
  }

}
