import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class GetTaskUseCase {
  final TaskRepository repository;
  GetTaskUseCase(this.repository);

  Future<TaskEntity?> call(String id, String userId) {
    return repository.getTask(id, userId);
  }
}
