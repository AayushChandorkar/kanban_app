import '../repository/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);

  Future<void> call(String id, String userId) {
    return repository.deleteTask(id, userId);
  }
}
