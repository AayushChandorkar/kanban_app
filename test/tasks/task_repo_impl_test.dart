import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/data/model/task_model.dart';
import 'package:kanban_app/features/tasks/data/repository_impl/task_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskRemoteDataSource mockRemote;
  late MockTaskLocalDataSource mockLocal;
  late TaskRepositoryImpl repository;
  const userId = "u123";

  setUp(() {
    mockRemote = MockTaskRemoteDataSource();
    mockLocal = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(mockRemote, mockLocal);
  });

  group("getAllTasks", () {
    test("returns cached tasks when available", () async {
      final cached = [
        TaskModel(
          id: "1",
          title: "t",
          description: "d",
          status: "todo",
          userId: userId,
          createdAt: DateTime.now(),
        )
      ];

      when(mockLocal.getAllTasks(userId))
          .thenAnswer((_) async => cached);

      final result = await repository.getAllTasks(userId);

      expect(result.length, 1);
      verify(mockLocal.getAllTasks(userId)).called(1);
    });

    test("fetches from remote when cache empty", () async {
      when(mockLocal.getAllTasks(userId))
          .thenAnswer((_) async => []);
      when(mockRemote.getAllTasks(userId))
          .thenAnswer((_) async => []);

      await repository.getAllTasks(userId);

      verify(mockRemote.getAllTasks(userId)).called(1);
    });
  });
}
