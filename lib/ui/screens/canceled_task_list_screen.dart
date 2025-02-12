import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_flutter/ui/controllers/get_task_list_controller.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';
import 'package:task_manager_flutter/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_flutter/ui/widgets/task_item_widget.dart';
import 'package:task_manager_flutter/ui/widgets/tm_app_bar.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_list_by_status_model.dart';

class CanceledTaskListScreen extends StatefulWidget {
  const CanceledTaskListScreen({super.key});

  @override
  State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
}

class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {
  final bool _getTasksSummaryByStatusProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? canceledTaskListModel;
  final GetTaskListController _getTaskListController= Get.find<GetTaskListController>();


  Future<void> _refreshData() async {
    await _getCanceledTaskListView(isFromRefresh: true);
    _getTaskListController.update();
  }

  @override
  void initState() {
    super.initState();
    _getCanceledTaskListView(isFromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TmAppBar(textTheme: textTheme), // App bar with custom theme
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

  Future<void> _getCanceledTaskListView({bool isFromRefresh = false}) async {
    bool cancelledTaskListInProgress = await _getTaskListController.getTaskList(
        isFromRefresh: isFromRefresh,
        statusName: 'Canceled');

    if(!cancelledTaskListInProgress){
      showSnackBarMessage(context, _getTaskListController.errorMessage);
    }
    _getTaskListController.update();
  }

}
