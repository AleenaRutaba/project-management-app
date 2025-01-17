import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'project_provider.dart';
import 'models/task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final String projectId;
  AddEditTaskScreen({required this.projectId});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String priority = 'High';
  String status = 'Pending';
  DateTime dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),
              DropdownButtonFormField<String>(
                value: priority,
                onChanged: (newValue) {
                  setState(() {
                    priority = newValue!;
                  });
                },
                items: ['High', 'Medium', 'Low']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                onChanged: (newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
                items: ['Pending', 'In Progress', 'Completed']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task task = Task(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
      );
      // Add task to project
      Provider.of<ProjectProvider>(context, listen: false)
          .addTaskToProject(widget.projectId, task);

      Navigator.pop(context); // Close the current screen
    }
  }
}
