class Task {
  String? id; // Allow id to be nullable
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String status;

  Task({
    this.id, // id is now optional
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? 'Untitled', // Provide default title
      description: map['description'] ??
          'No description provided', // Default description
      dueDate: DateTime.tryParse(map['dueDate']) ??
          DateTime.now(), // Fallback if date is invalid
      priority: map['priority'] ?? 'Medium', // Default priority
      status: map['status'] ?? 'Pending', // Default status
    );
  }
}
