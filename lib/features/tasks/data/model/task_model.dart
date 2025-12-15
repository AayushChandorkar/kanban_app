import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task_entity.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt),
      "userId": userId,
    };
  }

  factory TaskModel.fromFirestore(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      status: map["status"],
      createdAt: (map["createdAt"] as Timestamp).toDate(),
      userId: map["userId"],
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      status: status,
      createdAt: createdAt,
      userId: userId,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      createdAt: entity.createdAt,
      userId: entity.userId,
    );
  }
}
