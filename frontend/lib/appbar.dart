import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/colors.dart';

class CustomAppBar extends StatefulWidget {
  final int screenindex;
  const CustomAppBar({required this.screenindex, super.key});

  @override
  State<CustomAppBar> createState() => Custom_AppBarState();
}



class Custom_AppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
      padding: const EdgeInsets.symmetric(
          horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (widget.screenindex == 0) ? "Pomodoro Stage" : "Tasks List",
            style: GoogleFonts.robotoSlab(
                fontSize: 20, color: white),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            iconSize: 30,
            color: white,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}