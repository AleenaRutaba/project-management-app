import 'package:cloud_firestore/cloud_firestore.dart';

import 'task.dart';

class Project {
  String? id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  String status;
  String state; // Add this line for state

  List<Task> tasks;

  // Modify the constructor to include the 'state' parameter
  Project({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.state, // Add state to the constructor
    required this.tasks,
  });

  // Add fromMap and toMap methods for Firestore (if you are using Firestore)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      status: map['status'],
      state: map['state'], // Add state here
      tasks: (map['tasks'] as List).map((task) => Task.fromMap(task)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'state': state, // Add state here
      'tasks': tasks.map((task) => task.toMap()).toList(),
    };
  }
}
