import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_edit_task_screen.dart'; // Import the task screen
import 'models/project.dart';
import 'project_provider.dart'; // Import the provider for deleting project

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailsScreen({required this.project});

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title.isNotEmpty
            ? widget.project.title
            : 'Untitled'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${widget.project.description.isNotEmpty ? widget.project.description : 'No description available'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${widget.project.status.isNotEmpty ? widget.project.status : 'No status available'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Start Date: ${widget.project.startDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'End Date: ${widget.project.endDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Use Consumer to listen to changes in the ProjectProvider
            Consumer<ProjectProvider>(
              builder: (context, provider, child) {
                final project = provider.projects
                    .firstWhere((project) => project.id == widget.project.id);
                return project.tasks.isEmpty
                    ? Text('No tasks available')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: project.tasks.length,
                        itemBuilder: (context, index) {
                          final task = project.tasks[index];
                          return ListTile(
                            title: Text(task.title.isNotEmpty
                                ? task.title
                                : 'Untitled Task'),
                            subtitle: Text(
                                'Status: ${task.status.isNotEmpty ? task.status : 'Pending'}'),
                          );
                        },
                      );
              },
            ),
            SizedBox(height: 16),
            // Add Task Button
            ElevatedButton.icon(
              onPressed: () {
                if (widget.project.id != null &&
                    widget.project.id!.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditTaskScreen(projectId: widget.project.id!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Project ID is missing!"),
                  ));
                }
              },
              icon: Icon(Icons.add),
              label: Text('Add Task'),
            ),
            SizedBox(height: 16),
            // Delete Project Button
            ElevatedButton.icon(
              onPressed: () {
                if (widget.project.id != null &&
                    widget.project.id!.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Project'),
                      content:
                          Text('Are you sure you want to delete this project?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call the provider to delete the project
                            Provider.of<ProjectProvider>(context, listen: false)
                                .deleteProject(widget.project.id!);
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(
                                context); // Navigate back to the previous screen
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Project ID is missing!"),
                  ));
                }
              },
              icon: Icon(Icons.delete),
              label: Text('Delete Project'),
            ),
          ],
        ),
      ),
    );
  }
}
