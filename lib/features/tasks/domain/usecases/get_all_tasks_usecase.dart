import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class GetAllTasksUseCase {
  final TaskRepository repository;
  GetAllTasksUseCase(this.repository);

  Future<List<TaskEntity>> call(String userId) {
    return repository.getAllTasks(userId);
  }
}

