class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final String userId;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.userId,
  });
}
