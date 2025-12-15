import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/task_entity.dart';
import '../../model/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<void> createTask(TaskEntity task, String userId);
  Future<void> updateTask(TaskEntity task, String userId);
  Future<void> deleteTask(String id, String userId);
  Future<TaskEntity?> getTask(String id, String userId);
  Future<List<TaskEntity>> getAllTasks(String userId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl(this.firestore);

  CollectionReference _userTasks(String userId) {
    return firestore.collection("users").doc(userId).collection("tasks");
  }

  @override
  Future<void> createTask(TaskEntity task, String userId) async {
    await _userTasks(userId)
        .doc(task.id)
        .set(TaskModel.fromEntity(task).toFirestore())
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'unavailable',
          message: 'No internet',
        );
      },
    );
  }

  @override
  Future<void> updateTask(TaskEntity task, String userId) async {
    await _userTasks(userId)
        .doc(task.id)
        .update(TaskModel.fromEntity(task).toFirestore())
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'unavailable',
          message: 'No internet',
        );
      },
    );
  }

  @override
  Future<void> deleteTask(String id, String userId) async {
    await _userTasks(userId)
        .doc(id)
        .delete()
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'unavailable',
          message: 'No internet',
        );
      },
    );
  }

  @override
  Future<TaskEntity?> getTask(String id, String userId) async {
    final doc = await _userTasks(userId)
        .doc(id)
        .get()
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'unavailable',
          message: 'No internet',
        );
      },
    );

    if (!doc.exists) return null;

    return TaskModel.fromFirestore(doc.data() as Map<String, dynamic>)
        .toEntity();
  }

  @override
  Future<List<TaskEntity>> getAllTasks(String userId) async {
    final snapshot = await _userTasks(userId)
        .orderBy("createdAt", descending: true)
        .get()
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'unavailable',
          message: 'No internet',
        );
      },
    );

    return snapshot.docs
        .map((doc) => TaskModel.fromFirestore(
      doc.data() as Map<String, dynamic>,
    ).toEntity())
        .toList();
  }
}
