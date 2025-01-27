import 'package:flutter/material.dart';

import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/task_status_summary_counter_widget.dart';
import '../widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  Future<void> _refreshData() async {
    await _getTaskCountByStatus(isformRefresh: true);
    await _getNewTaskList(isformRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus(isformRefresh: false);
    _getNewTaskList(isformRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TMAppBar(textTheme: textTheme),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildTasksSummaryByStatus(),
                _buildTaskListView(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Visibility(
            visible: _getNewTaskListInProgress == false,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: newTaskListModel?.taskList?.length ?? 0,
              itemBuilder: (context, index) {
                return TaskItemWidget(
                  taskModel: newTaskListModel!.taskList![index],
                  taskColorByStatus: Colors.cyan.shade800,
                  status: 'New',
                  showEditButton: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksSummaryByStatus() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: _getTaskCountByStatusInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
            itemBuilder: (context, index) {
              final TaskCountModel model =
                  taskCountByStatusModel!.taskByStatusList![index];
              return TaskStatusSummaryCounterWidget(
                title: model.sId ?? '',
                count: model.sum.toString(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getTaskCountByStatus({bool isformRefresh = false}) async {
    if (!isformRefresh) {
      _getTaskCountByStatusInProgress = true;
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (response.isSuccess) {
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountByStatusInProgress = false;
    setState(() {});
  }

  Future<void> _getNewTaskList({bool isformRefresh = false}) async {
    if (!isformRefresh) {
      _getNewTaskListInProgress = true;
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));
    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }
}
