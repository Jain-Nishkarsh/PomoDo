import 'package:flutter/material.dart';
import 'package:myapp/pomodoro_screen.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/task_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PomodoroScreen(),
      routes: {
        '/tasks': (context) => const TasksScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
