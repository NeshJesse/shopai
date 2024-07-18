import 'package:flutter/material.dart';

// Enumeration to represent different task categories
enum TaskCategory {
  all,
  completed,
  pending,
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Future<void> _showAddTaskDialog(BuildContext context) async {
    String newTaskText = ''; // Text entered by the user for the new task

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTaskText = value; // Update newTaskText as the user types
            },
            decoration: InputDecoration(hintText: 'Enter task...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new task to the list and update the tasks
                //_addNewTask(newTaskText);
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Saka Price',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 63, 7, 136),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [],
        ),
      ),
      // Floating action button to add new task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add_box),
      ),

      backgroundColor: const Color(0xFFCECAB7),
    );
  }
}
