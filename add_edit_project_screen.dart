import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'project_provider.dart';
import 'models/project.dart';

class AddEditProjectScreen extends StatefulWidget {
  final Project? project;

  AddEditProjectScreen({this.project});

  @override
  _AddEditProjectScreenState createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 7));
  String status = 'In Progress';
  String state = 'Not Started';

  @override
  void initState() {
    super.initState();

    if (widget.project != null) {
      title = widget.project!.title ?? '';
      description = widget.project!.description ?? '';
      startDate = widget.project!.startDate;
      endDate = widget.project!.endDate;
      status = widget.project!.status ?? 'In Progress';
      state =
          widget.project!.state ?? 'Not Started'; // Initialize state if editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                initialValue: title,
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
                initialValue: description,
                onSaved: (value) => description = value!,
              ),
              SizedBox(height: 16),
              // Start Date and End Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Start Date: ${startDate.toLocal().toString().split(' ')[0]}'),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != startDate) {
                        setState(() {
                          startDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select Start Date'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'End Date: ${endDate.toLocal().toString().split(' ')[0]}'),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != endDate) {
                        setState(() {
                          endDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select End Date'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Status Dropdown
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: 'Status'),
                items: <String>[
                  'In Progress',
                  'Completed',
                  'Pending',
                  'On Hold'
                ].map((statusOption) {
                  return DropdownMenuItem<String>(
                    value: statusOption,
                    child: Text(statusOption),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                onSaved: (value) => status = value!,
              ),
              SizedBox(height: 16),
              // State Dropdown
              DropdownButtonFormField<String>(
                value: state,
                decoration: InputDecoration(labelText: 'State'),
                items: <String>['Not Started', 'In Progress', 'Completed']
                    .map((stateOption) {
                  return DropdownMenuItem<String>(
                    value: stateOption,
                    child: Text(stateOption),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    state = value!;
                  });
                },
                onSaved: (value) => state = value!,
              ),
              SizedBox(height: 16),
              // Save or Update Project Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveProject,
                    child: Text(widget.project == null
                        ? 'Save Project'
                        : 'Update Project'),
                  ),
                  if (widget.project != null)
                    ElevatedButton(
                      onPressed: _deleteProject,
                      child: Text('Delete Project'),
                      style: ElevatedButton.styleFrom(iconColor: Colors.red),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Project project = Project(
        id: widget.project?.id ?? DateTime.now().toString(),
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        status: status,
        state: 'Active', // Or the value you want for 'state'
        tasks: widget.project?.tasks ?? [],
      );

      if (widget.project == null) {
        // If it's a new project, add it
        Provider.of<ProjectProvider>(context, listen: false)
            .addProject(project);
      } else {
        // If editing, update the project
        Provider.of<ProjectProvider>(context, listen: false)
            .updateProject(project);
      }
      Navigator.pop(context);
    }
  }

  void _deleteProject() {
    if (widget.project != null) {
      String? projectId = widget.project!.id;
      if (projectId != null) {
        Provider.of<ProjectProvider>(context, listen: false)
            .deleteProject(projectId);
        Navigator.pop(context);
      }
    }
  }
}
