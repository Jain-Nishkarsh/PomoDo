import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

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
      },
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _remainingSeconds = 1500;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
       setState(() {
         if (_remainingSeconds > 0) {
           _remainingSeconds--;
         } else {
           timer.cancel(); // Stop the timer when it reaches zero
         }
       });
     });
  }


  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pomodoro Stage",
                          style: GoogleFonts.robotoSlab(
                              fontSize: 20, color: white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.account_circle),
                          iconSize: 30,
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              CircleAvatar(
                radius: 130,
                backgroundColor: borderColor,
                child: GestureDetector(
                  onTap: () {
                    // Handle circle tap
                  },
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: GoogleFonts.robotoSlab(
                      fontSize: 60,
                      letterSpacing: 4,
                      color: bgColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomCardNavigationBar(),
    );
  }
}

class BottomCardNavigationBar extends StatelessWidget {
  const BottomCardNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width + 12,
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        // border: Border.all(color: Colors.white, width: 6),
        border: Border(
          top: BorderSide(color: borderColor, width: 4),
          left: BorderSide(color: borderColor, width: 4),
          right: BorderSide(color: borderColor, width: 4),
          // right: BorderSide.none,
          bottom: BorderSide.none,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, -2),
            blurRadius: 6.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // Handle ongoing task tap
            },
            child: Container(
              // width: double.infinity,
              margin: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(40),
                // border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Center(
                child: Text(
                  'Ongoing Task',
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(height: 10),
          BottomNavigationBar(
            backgroundColor: bgColor,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Pomodoro',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Tasks',
              ),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/tasks');
              }
            },
          ),
        ],
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Tasks"),
      ),
      body: const Center(
        child: Text(
          'Tasks Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
