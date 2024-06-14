import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/colors.dart';

class PomodoroTimer extends StatefulWidget {
  final int initialTimeInSeconds;
  const PomodoroTimer({
    required this.initialTimeInSeconds,
    super.key,
  });

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int _remainingSeconds = 1500;
  Timer? _timer;
  bool _ispaused = true;
  bool _showText = true;
  Timer? _blinkTimer;

  void _startBlinking() {
    int blinkCycle = 0;
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        blinkCycle = (blinkCycle + 1) % 5;
        _showText = blinkCycle < 3;
      });
    });
  }

  void _stopBlinking() {
    _blinkTimer?.cancel();
  }

  void toggleTimer() {
    if (_timer == null) {
      _initializeTimer();
    } else {
      setState(() {
        if (_ispaused) {
          _stopBlinking();
          _showText = true;
        } else {
          _startBlinking();
        }
        _ispaused = !_ispaused;
      });
    }
  }

  void resetTimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Timer'),
        content: const Text('Are you sure you want to reset the timer?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _stopBlinking();
              _timer?.cancel();
              _timer = null;
              _ispaused = true;
              _remainingSeconds = widget.initialTimeInSeconds;
              _showText = true;
              setState(() {});
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _initializeTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_ispaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel(); // Stop the timer when it reaches zero
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialTimeInSeconds; // Initialize with the provided value
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        toggleTimer();
      },
      onDoubleTap: () {
        resetTimer();
      },
      child: CircleAvatar(
          radius: (_ispaused) ? 130 : 140,
          backgroundColor: borderColor,
          child: Visibility(
            visible: _showText,
            child: Text(
              _formatTime(_remainingSeconds),
              style: GoogleFonts.robotoSlab(
                fontSize: 60,
                letterSpacing: 4,
                color: bgColor,
              ),
            ),
          )),
    );

  }
}
