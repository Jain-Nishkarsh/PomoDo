import 'package:flutter/material.dart';
import 'package:myapp/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/todo_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<dynamic> _data = [];
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _taskTitleController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final response = await http.get(Uri.parse('$backendURL/api/tasks/'));
    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _updateTask(index) async {
    final response = await http.patch(
      Uri.parse('$backendURL/api/tasks/${_data[index]['static_id']}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, bool>{
        'completed': _data[index]['completed'],
      }),
    );

    if (response.statusCode == 200) {
      print('Task updated successfully');
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> _deleteTask(index) async {
    final response = await http.delete(
      Uri.parse('$backendURL/api/tasks/${_data[index]['static_id']}/'),
    );

    if (response.statusCode == 204) {
      print('Task deleted successfully');
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> _createTask(String title, String dueDate) async {

    final response = await http.post(
      Uri.parse('$backendURL/api/tasks/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'due_date': dueDate,
      }),
    );

    if (response.statusCode == 201) {
      print('Task created successfully');
      _loadData();
    } else {
      throw Exception('Failed to create task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Expanded(
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            final todoitem = ToDoItem(
                title: _data[index]['title'],
                isComplete: _data[index]['completed'],
                dueDate: _data[index]['due_date']);

            return ToDoListTile(
              item: todoitem,
              onChanged: (value) {
                setState(() {
                  _data[index]['completed'] = value;
                });

                _updateTask(index);
              },
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteTask(index);
                          setState(() {
                            _data.removeAt(index);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create Task'),
              backgroundColor: borderColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskTitleController,
                    decoration: const InputDecoration(
                      hintText: 'Task Title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dueDateController,
                    decoration: const InputDecoration(
                      hintText: 'Due Date',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: accentColor)),
                ),
                TextButton(
                  onPressed: () {
                    String taskTitle = _taskTitleController.text;
                    String dueDate = _dueDateController.text;
                    _createTask(taskTitle, dueDate);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Create',
                      style: TextStyle(color: accentColor)),
                ),
              ],
            ),
          );
        },
        backgroundColor: borderColor,
        foregroundColor: accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
