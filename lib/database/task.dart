class Task {
  String? id;
  String title;
  bool isDone;
  int createdAt;

  Task({
    this.id,
    required this.title,
    this.isDone = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone, 'createdAt': createdAt};
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'],
      isDone: map['isDone'],
      createdAt: map['createdAt'],
    );
  }
}
