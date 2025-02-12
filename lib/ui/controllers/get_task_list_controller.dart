import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class GetTaskListController extends GetxController{
  bool isDataProgress = false;
  late  String _errorMessage;
  String get errorMessage => _errorMessage;

  TaskListByStatusModel? _taskListByStatusModel;
  List<TaskModel> get taskListModel => _taskListByStatusModel?.taskList ?? [];

  Future<bool> getTaskList({required bool isFromRefresh, required String statusName}) async {
    bool getTaskListIsSuccess = false;
    if (!isFromRefresh) {
      isDataProgress = true;
      update();
    }

    NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl(statusName));

    if (response.isSuccess) {
      _taskListByStatusModel =
          TaskListByStatusModel.fromJson(response.responseData!);
      getTaskListIsSuccess = true;// Set success
      update();
    } else {
      _errorMessage = response.errorMessage; // Set error message
    }

    isDataProgress = false;
    update();
    return getTaskListIsSuccess;
  }


}