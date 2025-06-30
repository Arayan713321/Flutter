import 'package:flutter/material.dart';
import '../database/task_database.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';
// ignore: duplicate_import
import 'add_task_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskDatabase.instance.readAllTasks();
  }

  void _refreshTasks() {
    setState(() {
      tasks = TaskDatabase.instance.readAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Manager')),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          } else {
            return ListView(
              children: snapshot.data!
                  .map((task) => ListTile(
                        title: Text(task.title),
                        subtitle: Text("${task.category} • ${task.priority}"),
                        trailing: Text(task.dueDate),
                      ))
                  .toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (result == true) {
            _refreshTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
