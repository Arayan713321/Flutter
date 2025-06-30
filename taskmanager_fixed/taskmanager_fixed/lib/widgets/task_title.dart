import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../database/task_database.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDeleted;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text("${task.category} • ${task.priority}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(task.dueDate),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await TaskDatabase.instance.delete(task.id!);
              onDeleted();
            },
          ),
        ],
      ),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditTaskScreen(task: task),
          ),
        );
        if (result == true) {
          onDeleted(); // Refresh after editing
        }
      },
    );
  }
}

// ignore: non_constant_identifier_names
AddEditTaskScreen({required Task task}) {
}
