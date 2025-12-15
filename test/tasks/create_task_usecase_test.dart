import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/domain/entities/task_entity.dart';
import 'package:kanban_app/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskRepository mockRepo;
  late CreateTaskUseCase usecase;

  setUp(() {
    mockRepo = MockTaskRepository();
    usecase = CreateTaskUseCase(mockRepo);
  });

  test("should call repository.createTask", () async {
    final task = TaskEntity(
      id: "1",
      title: "t",
      description: "d",
      status: "todo",
      createdAt: DateTime.now(),
      userId: "u1",
    );

    when(mockRepo.createTask(task, "u1"))
        .thenAnswer((_) async {});

    await usecase(task, "u1");

    verify(mockRepo.createTask(task, "u1")).called(1);
  });
}
