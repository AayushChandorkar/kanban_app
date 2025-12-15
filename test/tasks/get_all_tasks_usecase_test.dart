import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/domain/entities/task_entity.dart';
import 'package:kanban_app/features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskRepository mockRepository;
  late GetAllTasksUseCase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetAllTasksUseCase(mockRepository);
  });

  test("should return list of tasks from repository.getAllTasks()", () async {
    const userId = "user123";

    final tasks = [
      TaskEntity(
        id: "1",
        title: "Task",
        description: "Desc",
        status: "todo",
        createdAt: DateTime.now(),
        userId: userId,
      ),
    ];

    when(mockRepository.getAllTasks(userId))
        .thenAnswer((_) async => tasks);

    final result = await usecase(userId);

    expect(result, tasks);
    verify(mockRepository.getAllTasks(userId)).called(1);
  });
}
