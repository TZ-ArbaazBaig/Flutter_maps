// models/todo.dart
class Todo {
  final int id;
  String title;
  String description;
  int estimatedHours;
  String? assignee;
  String status;
  String priority;
  String imagePath;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedHours,
    this.assignee,
    required this.status,
    required this.priority,
    this.imagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'estimatedHours': estimatedHours,
      'assignee': assignee,
      'status': status,
      'priority': priority,
      'imagePath': imagePath,
    };
  }
}
