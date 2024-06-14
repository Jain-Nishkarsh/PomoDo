import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/bottomcard.dart';
import 'package:myapp/colors.dart';
import 'package:myapp/timer.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
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
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              const PomodoroTimer(initialTimeInSeconds: 300),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomCardNavigationBar(),
    );
  }
}