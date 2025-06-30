class Task {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String dueDate;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': dueDate,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      dueDate: map['dueDate'],
    );
  }

  Task copyWith({int? id}) {
    return Task(
      id: id ?? this.id,
      title: title,
      description: description,
      category: category,
      priority: priority,
      dueDate: dueDate,
    );
  }
}
