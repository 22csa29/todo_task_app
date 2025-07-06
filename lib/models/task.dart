class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  bool isComplete;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isComplete = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
