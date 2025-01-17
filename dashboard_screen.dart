import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'project_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          int totalProjects = provider.projects.length;
          int completedTasks = provider.projects
              .expand((project) => project.tasks)
              .where((task) => task.status == 'Completed')
              .length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Projects: $totalProjects',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 10),
                Text(
                  'Completed Tasks: $completedTasks',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
