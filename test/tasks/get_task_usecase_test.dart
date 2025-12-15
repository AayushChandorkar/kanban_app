import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/domain/entities/task_entity.dart';
import 'package:kanban_app/features/tasks/domain/usecases/get_task_usecase.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskRepository mockRepository;
  late GetTaskUseCase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetTaskUseCase(mockRepository);
  });

  test("should return task from repository.getTask()", () async {
    const id = "1";
    const userId = "user123";

    final task = TaskEntity(
      id: id,
      title: "Test",
      description: "Desc",
      status: "todo",
      createdAt: DateTime.now(),
      userId: userId,
    );

    when(mockRepository.getTask(id, userId))
        .thenAnswer((_) async => task);

    final result = await usecase(id, userId);

    expect(result, task);
    verify(mockRepository.getTask(id, userId)).called(1);
  });
}
