import 'package:get/get.dart';
import 'package:task_manager_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_manager_flutter/data/models/task_model.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskController extends GetxController {
  bool _getTaskListInProgress = false;

  bool get getTaskListInProgress => _getTaskListInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  TaskListByStatusModel? _taskListByStatusModel;

  List<TaskModel> get taskList => _taskListByStatusModel?.taskList ?? [];

  Future<bool> getTaskList({bool isformRefresh = false}) async {
    bool isSuccess = false;

    if (!isformRefresh) {
      _getTaskListInProgress = true;
      update();
    }

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));
    if (response.isSuccess) {
      _taskListByStatusModel =
          TaskListByStatusModel.fromJson(response.responseData!);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getTaskListInProgress = false;
    update();
    return isSuccess;
  }
}
