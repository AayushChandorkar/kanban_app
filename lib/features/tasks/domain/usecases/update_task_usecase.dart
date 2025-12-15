import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<void> call(TaskEntity task, String userId) {
    return repository.updateTask(task,userId);
  }
}
