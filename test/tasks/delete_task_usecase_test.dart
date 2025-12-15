import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskRepository mockRepository;
  late DeleteTaskUseCase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = DeleteTaskUseCase(mockRepository);
  });

  test("should call repository.deleteTask()", () async {
    const id = "1";
    const userId = "user123";

    when(mockRepository.deleteTask(id, userId))
        .thenAnswer((_) async {});

    await usecase(id, userId);

    verify(mockRepository.deleteTask(id, userId)).called(1);
  });
}
