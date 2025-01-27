import 'package:flutter/material.dart';
import 'package:task_manager_flutter/data/models/task_model.dart';
import 'package:task_manager_flutter/data/services/network_caller.dart';
import 'package:task_manager_flutter/data/utils/urls.dart';
import 'package:task_manager_flutter/ui/widgets/snack_bar_message.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
    required this.status,
    required this.taskColorByStatus,
    required this.showEditButton,
  });

  final TaskModel taskModel;
  final String status;
  final Color taskColorByStatus;
  final bool showEditButton;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.description ?? '',
              overflow: TextOverflow.ellipsis,
            ),
            Text('Date: ${widget.taskModel.createdDate ?? ''}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    label: Text(widget.status),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    backgroundColor: widget.taskColorByStatus,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteTaskMessage(context);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    if (widget.showEditButton)
                      IconButton(
                        onPressed: () {
                          _showChangeStatusDialog(id: widget.taskModel.sId);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Color _getStatusColor(String status) {
  //   if (status == 'New') {
  //     return Colors.blue;
  //   } else if (status == 'Progress') {
  //     return Colors.yellow;
  //   } else if (status == 'Canceled') {
  //     return Colors.red;
  //   } else {
  //     return Colors.black;
  //   }
  // }

  Future<dynamic> _deleteTaskMessage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure ?'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  showSnackBarMessage(context, 'Task has been deleted');
                  await _deleteTask(widget.taskModel.sId ?? '', context);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
            ],
          );
        });
  }

  Future<void> _deleteTask(String id, BuildContext context) async {
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(id),
    );
    if (response.isSuccess) {
      Navigator.pop(context);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _showChangeStatusDialog({required String? id}) {
    if (id == null) {
      showSnackBarMessage(context, 'Invalid Task Id');
      return;
    }

    List<String> listOfStatus = [];
    if (widget.status == 'New') {
      listOfStatus = ['Progress', 'Completed', 'Canceled'];
    } else if (widget.status == 'Progress') {
      listOfStatus = ['Completed', 'Canceled'];
    } else if (widget.status == 'Completed') {
      listOfStatus = ['Canceled'];
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Task Status'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              for (String status in listOfStatus) ...[
                const Divider(height: 0),
                ListTile(
                  title: Text(status),
                  onTap: () {
                    _updateTodoStatus(id, status);
                  },
                ),
              ],
            ]),
          );
        });
  }

  void _updateTodoStatus(String id, String status) async {
    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.updateTaskStatusUrl(id, status));

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task update successful');
      setState(() {
        widget.taskModel.status = status;
        Navigator.pop(context);
      });
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
