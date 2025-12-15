import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/domain/entities/task_entity.dart';
import 'package:kanban_app/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskRepository mockRepository;
  late UpdateTaskUseCase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = UpdateTaskUseCase(mockRepository);
  });

  test("should call repository.updateTask()", () async {
    final task = TaskEntity(
      id: "1",
      title: "Update",
      description: "Desc",
      status: "todo",
      createdAt: DateTime.now(),
      userId: "user123",
    );

    when(mockRepository.updateTask(task, "user123"))
        .thenAnswer((_) async {});

    await usecase(task, "user123");

    verify(mockRepository.updateTask(task, "user123")).called(1);
  });
}
