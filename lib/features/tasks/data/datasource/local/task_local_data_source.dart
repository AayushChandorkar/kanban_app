import 'package:kanban_app/features/tasks/data/datasource/local/task_database.dart';

import '../../model/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> cacheTask(TaskModel task);
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<TaskModel?> getTask(String id);
  Future<List<TaskModel>> getAllTasks(String userId);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final TaskDriftDatabase db;

  TaskLocalDataSourceImpl(this.db);

  @override
  Future<void> cacheTask(TaskModel task) async {
    await db.upsertTask(
      TaskTableCompanion.insert(
        id: task.id,
        title: task.title,
        description: task.description,
        status: task.status,
        createdAt: task.createdAt,
        userId: task.userId,
      ),
    );
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    for (var t in tasks) {
      await cacheTask(t);
    }
  }

  @override
  Future<TaskModel?> getTask(String id) async {
    final data = await db.getTask(id);
    if (data == null) return null;
    return TaskModel(
      id: data.id,
      title: data.title,
      description: data.description,
      status: data.status,
      createdAt: data.createdAt,
      userId: data.userId
    );
  }

  @override
  Future<List<TaskModel>> getAllTasks(String userId) async {
    final list = await db.getAllTasksForUser(userId);
    return list.map((t) => TaskModel(
      id: t.id,
      title: t.title,
      description: t.description,
      status: t.status,
      createdAt: t.createdAt,
      userId: t.userId,
    )).toList();
  }


  @override
  Future<void> deleteTask(String id) => db.deleteTask(id);
}
