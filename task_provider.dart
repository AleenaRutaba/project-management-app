import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_edit_project_screen.dart';
import 'project_details_screen.dart';
import 'project_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          if (provider.projects.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.title),
                subtitle: Text('Status: ${project.status}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectDetailsScreen(project: project),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditProjectScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
