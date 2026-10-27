class CampusTask {
  final String id;
  final String title;
  final String category;
  final DateTime dueDate;
  final bool isDone;

  const CampusTask({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    this.isDone = false,
  });

  CampusTask copyWith(
      {String? title, String? category, DateTime? dueDate, bool? isDone}) {
    return CampusTask(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'dueDate': dueDate.toIso8601String(),
        'isDone': isDone,
      };

  factory CampusTask.fromJson(Map<String, dynamic> json) => CampusTask(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        dueDate: DateTime.parse(json['dueDate'] as String),
        isDone: json['isDone'] as bool? ?? false,
      );
}
