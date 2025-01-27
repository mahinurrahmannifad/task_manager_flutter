import 'package:flutter/material.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';
import 'package:task_manager_flutter/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_flutter/ui/widgets/tm_app_bar.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/task_item_widget.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() =>
      _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getTasksSummaryByStatusProgress =
      false;

  TaskCountByStatusModel?
      taskCountByStatusModel;
  TaskListByStatusModel?
      completedTaskListModel;
  TaskModel? taskModel;


  Future<void> _refreshAllData() async {
    // await _getTaskCountByStatus(isFromRefresh: false);
    await _getCompletedTaskListView(isFromRefresh: false);
  }

  @override
  void initState() {
    super.initState();
    //_getTaskCountByStatus(isFromRefresh: true);
    _getCompletedTaskListView(isFromRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme;

    return Scaffold(
      appBar: TMAppBar(textTheme: textTheme),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //_buildTasksSummaryByStatus(),
                _buildTaskListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // Ensures scrolling is always enabled
          child: Visibility(
            visible: _getTasksSummaryByStatusProgress == false,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: completedTaskListModel?.taskList?.length ?? 0,
              // List item count
              itemBuilder: (context, index) {
                // Each task is represented as a TaskItemWidget
                return TaskItemWidget(
                  taskModel: completedTaskListModel!.taskList![index],
                  status: 'Completed',
                  taskColorByStatus: Colors.green,
                  showEditButton: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTasksSummaryByStatus() {
  //   return Visibility(
  //     visible: _getTasksSummaryByStatusProgress == false,
  //     replacement: const Center(child: CircularProgressIndicator()),
  //     child: SizedBox(
  //       height: 100,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
  //         itemBuilder: (context, index) {
  //
  //           final TaskCountModel model = taskCountByStatusModel!.taskByStatusList![index];
  //           return TaskStatusSummaryCounterWidget(
  //             count: model.sum.toString(),
  //             title: model.sId ?? '',
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  //
  // Future<void> _getTaskCountByStatus({bool isFromRefresh = false}) async {
  //   if (!isFromRefresh) {
  //     _getTasksSummaryByStatusProgress = true;
  //     setState(() {});
  //   }
  //
  //   NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
  //
  //   if (response.isSuccess) {
  //     taskCountByStatusModel = TaskCountByStatusModel.fromJson(response.responseData!);
  //   } else {
  //     showSnackBarMessage(context, response.errorMessage);
  //   }
  //   _getTasksSummaryByStatusProgress = false;
  //   setState(() {});
  // }

  Future<void> _getCompletedTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Completed'));

    if (response.isSuccess) {
      completedTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context,
          response.errorMessage);
    }
    _getTasksSummaryByStatusProgress =
        false;
    setState(() {});
  }
}
