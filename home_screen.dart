import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_edit_project_screen.dart';
import 'main.dart';
import 'project_details_screen.dart';
import 'project_provider.dart';
import 'auth_service.dart';
import 'dashboard_screen.dart'; // Import the DashboardScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProjectProvider>(context, listen: false).fetchProjects();

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          TextButton.icon(
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthWrapper()),
              );
            },
            icon: Icon(Icons.logout, color: Colors.black),
            label: Text(
              'Sign Out',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          if (provider.projects.isEmpty) {
            return Center(
              child: Text('No projects available. Please add a project!'),
            );
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
