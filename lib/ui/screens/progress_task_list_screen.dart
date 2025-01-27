import 'package:flutter/material.dart';
import 'package:task_manager_flutter/data/models/task_count_by_status_model.dart';
import 'package:task_manager_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_manager_flutter/data/models/task_model.dart';
import 'package:task_manager_flutter/data/services/network_caller.dart';
import 'package:task_manager_flutter/data/utils/urls.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  TaskListByStatusModel? progressTaskListModel;
  bool _getProgressTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskModel? taskModel;

  Future<void> _refreshData() async {
    // await _getTaskCountByStatus(isformRefresh: false);
    await _getProgressTaskList(isformRefresh: false);
  }

  @override
  void initState() {
    _getProgressTaskList(isformRefresh: true);
    //_getTaskCountByStatus(isformRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TMAppBar(
        textTheme: textTheme,
      ),
      body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ScreenBackground(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // SizedBox(height: 100,
                  //     child: _buildProgressTaskSummaryByStatus()),
                  _buildTaskListView()
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Visibility(
            visible: _getProgressTaskListInProgress == false,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: progressTaskListModel?.taskList?.length ?? 0,
              itemBuilder: (context, index) {
                return TaskItemWidget(
                  taskModel: progressTaskListModel!.taskList![index],
                  taskColorByStatus: Colors.orangeAccent,
                  status: 'Progress',
                  showEditButton: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildProgressTaskSummaryByStatus() {
  //   return Visibility(
  //     visible: _getProgressTaskListInProgress == false,
  //     replacement: CenteredCircularProgressIndicator(),
  //     child: SizedBox(
  //       height: 100,
  //       child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
  //           itemBuilder: (context, index) {
  //             final TaskCountModel model =
  //                 taskCountByStatusModel!.taskByStatusList![index];
  //             return TaskStatusSummaryCounterWidget(
  //               count: model.sum.toString(),
  //               title: model.sId ?? '',
  //             );
  //           }),
  //     ),
  //   );
  // }

  Future<void> _getProgressTaskList({bool isformRefresh = true}) async {
    if (!isformRefresh) {
      _getProgressTaskListInProgress = true;
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Progress'));
    if (response.isSuccess) {
      progressTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }

// Future<void> _getTaskCountByStatus({required bool isformRefresh}) async {
//   if (!isformRefresh) {
//     _getProgressTaskListInProgress = true;
//     setState(() {});
//   }
//   final NetworkResponse response =
//       await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
//   if (response.isSuccess) {
//     taskCountByStatusModel =
//         TaskCountByStatusModel.fromJson(response.responseData!);
//   } else {
//     showSnackBarMessage(context, response.errorMessage);
//   }
//   _getProgressTaskListInProgress = false;
//   setState(() {});
// }
}
