// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../database/task_database.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String category = 'Academic';
  String priority = 'Medium';
  String dueDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => title = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => description = val!,
              ),
              DropdownButtonFormField(
                value: category,
                items: ['Academic', 'Personal']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => category = val!,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              DropdownButtonFormField(
                value: priority,
                items: ['High', 'Medium', 'Low']
                    .map((pri) => DropdownMenuItem(value: pri, child: Text(pri)))
                    .toList(),
                onChanged: (val) => priority = val!,
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Due Date (e.g., 2025-06-21)'),
                onSaved: (val) => dueDate = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  await TaskDatabase.instance.create(Task(
                    title: title,
                    description: description,
                    category: category,
                    priority: priority,
                    dueDate: dueDate,
                  ));
                  Navigator.pop(context, true);
                },
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
