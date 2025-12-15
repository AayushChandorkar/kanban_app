import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(TaskEntity task, String userId);
  Future<void> updateTask(TaskEntity task, String userId);
  Future<void> deleteTask(String id, String userId);
  Future<TaskEntity?> getTask(String id, String userId);
  Future<List<TaskEntity>> getAllTasks(String userId);
}
