import 'package:flutter/material.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';
import 'package:task_manager_flutter/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_flutter/ui/widgets/task_item_widget.dart';
import 'package:task_manager_flutter/ui/widgets/tm_app_bar.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CanceledTaskListScreen extends StatefulWidget {
  const CanceledTaskListScreen({super.key});

  @override
  State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
}

class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {
  bool _getTasksSummaryByStatusProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? canceledTaskListModel;

  // Refresh both task count and task list
  Future<void> _refreshData() async {
    //await _getTaskCountByStatus(isFromRefresh: true); // Refresh task count
    await _getCanceledTaskListView(
        isFromRefresh: true); // Refresh canceled task list
  }

  @override
  void initState() {
    super.initState();
    // _getTaskCountByStatus(isFromRefresh: false); // Load task count initially
    _getCanceledTaskListView(
        isFromRefresh: false); // Load canceled tasks initially
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TMAppBar(textTheme: textTheme), // App bar with custom theme
      body: RefreshIndicator(
        onRefresh: _refreshData, // Enable pull-to-refresh functionality
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // SizedBox(height: 100,
                //     child: _buildTasksSummaryByStatus()), // Task summary by status
                _buildTaskListView(),
                // Canceled task list
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the list view of canceled tasks
  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Visibility(
            visible: _getTasksSummaryByStatusProgress == false,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: canceledTaskListModel?.taskList?.length ?? 0,
              itemBuilder: (context, index) {
                return TaskItemWidget(
                  taskModel: canceledTaskListModel!.taskList![index],
                  status: 'Canceled',
                  showEditButton: false,
                  taskColorByStatus: Colors.red.shade800,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Builds the summary of tasks by status (e.g., Canceled, Pending, etc.)
  // Widget _buildTasksSummaryByStatus() {
  //   return Visibility(
  //     visible: _getTasksSummaryByStatusProgress == false,
  //     replacement: const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //     child: SizedBox(
  //       height: 100,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
  //         itemBuilder: (context, index) {
  //           final TaskCountModel model =
  //           taskCountByStatusModel!.taskByStatusList![index];
  //           return TaskStatusSummaryCounterWidget(
  //             count: model.sum.toString(),
  //             title: model.sId ?? '',
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Fetch task count summary by status
  // Future<void> _getTaskCountByStatus({bool isFromRefresh = false}) async {
  //   if (!isFromRefresh) {
  //     _getTasksSummaryByStatusProgress = true;
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response =
  //   await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
  //
  //   if (response.isSuccess) {
  //     taskCountByStatusModel =
  //         TaskCountByStatusModel.fromJson(response.responseData!);
  //   } else {
  //     showSnackBarMessage(context, response.errorMessage);
  //   }
  //   _getTasksSummaryByStatusProgress = false;
  //   setState(() {});
  // }

  // Fetch the list of canceled tasks
  Future<void> _getCanceledTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('Canceled'),
    );

    if (response.isSuccess) {
      canceledTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTasksSummaryByStatusProgress = false;
    setState(() {});
  }
}
