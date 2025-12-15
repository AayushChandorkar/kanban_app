import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../datasource/local/task_local_data_source.dart';
import '../datasource/remote/task_data_source.dart';
import '../model/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;

  TaskRepositoryImpl(this.remote, this.local);

  @override
  Future<void> createTask(TaskEntity task, String userId) async {
    await remote.createTask(task, userId);
    await local.cacheTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(TaskEntity task, String userId) async {
    await remote.updateTask(task, userId);
    await local.cacheTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id, String userId) async {
    await remote.deleteTask(id, userId);
    await local.deleteTask(id);
  }

  @override
  Future<TaskEntity?> getTask(String id, String userId) async {
    final localTask = await local.getTask(id);
    if (localTask != null) return localTask.toEntity();

    final remoteTask = await remote.getTask(id, userId);
    if (remoteTask != null) {
      await local.cacheTask(TaskModel.fromEntity(remoteTask));
    }

    return remoteTask;
  }

  @override
  Future<List<TaskEntity>> getAllTasks(String userId) async {
    try {
      final cached = await local.getAllTasks(userId);

      if (cached.isNotEmpty) {
        _refreshRemoteTasks(userId);
        return cached.map((e) => e.toEntity()).toList();
      }

      final remoteTasks = await remote.getAllTasks(userId);

      await local.cacheTasks(remoteTasks.map(TaskModel.fromEntity).toList());
      return remoteTasks;
    } catch (e) {
      final cached = await local.getAllTasks(userId);

      if (cached.isNotEmpty) {
        return cached.map((e) => e.toEntity()).toList();
      }

      throw Exception("NO_INTERNET");
    }
  }

  Future<void> _refreshRemoteTasks(String userId) async {
    final remoteTasks = await remote.getAllTasks(userId);
    await local.cacheTasks(remoteTasks.map(TaskModel.fromEntity).toList());
  }
}
