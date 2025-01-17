import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/project.dart';
import 'models/task.dart';

class ProjectProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  Future<void> fetchProjects() async {
    try {
      final snapshot = await _firestore.collection('projects').get();
      _projects = snapshot.docs.map((doc) {
        return Project.fromMap({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching projects: $e");
    }
  }

  Future<void> addProject(Project project) async {
    try {
      final docRef =
          await _firestore.collection('projects').add(project.toMap());
      project.id = docRef.id;
      _projects.add(project);
      notifyListeners();
    } catch (e) {
      print("Error adding project: $e");
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = project;
      }
      notifyListeners();
    } catch (e) {
      print("Error updating project: $e");
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      _projects.removeWhere((project) => project.id == projectId);
      notifyListeners();
    } catch (e) {
      print("Error deleting project: $e");
    }
  }

  void addTaskToProject(String projectId, Task task) {
    final projectIndex =
        _projects.indexWhere((project) => project.id == projectId);
    if (projectIndex >= 0) {
      _projects[projectIndex].tasks.add(task);
      notifyListeners(); // Notify listeners so that the UI is updated
    }
  }

  Future<void> updateTaskForProject(String projectId, Task updatedTask) async {
    try {
      final project =
          _projects.firstWhere((project) => project.id == projectId);
      final taskIndex =
          project.tasks.indexWhere((task) => task.id == updatedTask.id);
      if (taskIndex != -1) {
        project.tasks[taskIndex] = updatedTask;

        await _firestore.collection('projects').doc(projectId).update({
          'tasks': project.tasks.map((task) => task.toMap()).toList(),
        });

        notifyListeners();
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  Future<void> deleteTaskFromProject(String projectId, String taskId) async {
    try {
      final project =
          _projects.firstWhere((project) => project.id == projectId);
      final taskIndex = project.tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        project.tasks.removeAt(taskIndex);

        await _firestore.collection('projects').doc(projectId).update({
          'tasks': project.tasks.map((task) => task.toMap()).toList(),
        });

        notifyListeners();
      }
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
