import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/colors.dart';

class ToDoItem {
  final String title;
  final bool isComplete;
  final String dueDate;

  ToDoItem({
    required this.title,
    required this.isComplete,
    required this.dueDate,
  });

  DateTime get parsedDueDate => DateTime.parse(dueDate);
}

class ToDoListTile extends StatelessWidget {
  final ToDoItem item;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  ToDoListTile({
    required this.item,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: borderColor,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Checkbox(
          value: item.isComplete,
          onChanged: onChanged,
          activeColor: black,
        ),
        title: Text(
          item.title,
          style: GoogleFonts.robotoSlab(
            fontWeight: FontWeight.bold,
            decoration: item.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Due: ${DateFormat.yMMMd().format(item.parsedDueDate)}',
          style: TextStyle(
            color: item.isComplete ? Colors.grey : red,
            decoration: item.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
