import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/colors.dart';

class BottomCardNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomCardNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

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
        border: Border(
          top: BorderSide(color: borderColor, width: 4),
          left: BorderSide(color: borderColor, width: 4),
          right: BorderSide(color: borderColor, width: 4),
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
            currentIndex: currentIndex,
            onTap: onTap,
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
            // onTap: (index) {
            //   if (index == 1) {
            //     Navigator.pushNamed(context, '/tasks');
            //   }
            // },
          ),
        ],
      ),
    );
  }
}
