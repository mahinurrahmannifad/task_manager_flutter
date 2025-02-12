import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_flutter/data/models/task_count_by_status_model.dart';
import 'package:task_manager_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_manager_flutter/data/models/task_model.dart';
import '../controllers/get_task_list_controller.dart';
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
  final bool _getProgressTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskModel? taskModel;
  final GetTaskListController _getTaskListController =
      Get.find<GetTaskListController>();

  Future<void> _refreshData() async {
    await _getProgressTaskList(isformRefresh: false);
    _getTaskListController.update();
  }

  @override
  void initState() {
    _getProgressTaskList(isformRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TmAppBar(
        textTheme: textTheme,
      ),
      body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ScreenBackground(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [_buildTaskListView()],
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

  Future<void> _getProgressTaskList({bool isformRefresh = false}) async {
    bool progressTaskListInProgress = await _getTaskListController.getTaskList(
        isFromRefresh: isformRefresh, statusName: 'Progress');
    if (!progressTaskListInProgress) {
      showSnackBarMessage(context, _getTaskListController.errorMessage);
    }
    _getTaskListController.update();
  }
}
