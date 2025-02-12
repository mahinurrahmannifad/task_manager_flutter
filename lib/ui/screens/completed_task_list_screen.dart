import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_flutter/ui/controllers/get_task_list_controller.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';
import 'package:task_manager_flutter/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_flutter/ui/widgets/tm_app_bar.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../widgets/task_item_widget.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  final bool _getTasksSummaryByStatusProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? completedTaskListModel;
  TaskModel? taskModel;
  final GetTaskListController _getTaskListController= Get.find<GetTaskListController>();

  Future<void> _refreshAllData() async {
    await _getCompletedTaskListView(isFromRefresh: false);
    _getTaskListController.update();
  }

  @override
  void initState() {
    super.initState();
    _getCompletedTaskListView(isFromRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TMAppBar(textTheme: textTheme),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
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


  Future<void> _getCompletedTaskListView({bool isFromRefresh = false}) async {
    bool completedTaskListInProgress= await _getTaskListController.getTaskList(
        isFromRefresh: isFromRefresh,
        statusName: 'Completed');

    if(!completedTaskListInProgress){
      showSnackBarMessage(context, _getTaskListController.errorMessage);
    }
    _getTaskListController.update();
    }
}
