import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;
  CreateTaskUseCase(this.repository);

  Future<void> call(TaskEntity task, String userId) {
    return repository.createTask(task, userId);
  }
}
