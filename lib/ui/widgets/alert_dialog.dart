import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    BuildContext context, {
      required Widget text,
      required String message,
      required VoidCallback confirmAction,
      VoidCallback? cancelAction,
    }) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.add_alert_outlined),
            const SizedBox(width: 8),
            text
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              confirmAction();
              /// Fetches the new task list from the network
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              if (cancelAction != null) {
                cancelAction();
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'No',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}