import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/domain/entities/task_entity.dart';
import 'package:kanban_app/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:kanban_app/features/tasks/presentation/bloc/task_events.dart';
import 'package:kanban_app/features/tasks/presentation/bloc/task_states.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  late MockCreateTaskUseCase mockCreate;
  late MockUpdateTaskUseCase mockUpdate;
  late MockDeleteTaskUseCase mockDelete;
  late MockGetAllTasksUseCase mockGetAll;
  late TaskBloc bloc;

  const userId = "u1";
  const testStatus = "todo";

  setUp(() {
    mockCreate = MockCreateTaskUseCase();
    mockUpdate = MockUpdateTaskUseCase();
    mockDelete = MockDeleteTaskUseCase();
    mockGetAll = MockGetAllTasksUseCase();

    bloc = TaskBloc(
      createTask: mockCreate,
      updateTask: mockUpdate,
      deleteTask: mockDelete,
      getAllTasks: mockGetAll,
    );
  });

  final task = TaskEntity(
    id: "1",
    title: "t",
    description: "d",
    status: testStatus,
    userId: userId,
    createdAt: DateTime.now(),
  );

  test("LoadTasks emits loading → TaskLoaded", () async {
    when(mockGetAll.call(userId)).thenAnswer((_) async => [task]);

    final expected = [
      const TaskLoading(status: testStatus),
      isA<TaskLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(LoadTasks(userId: userId));
  });

  test("CreateTaskEvent success emits correct sequence", () async {
    when(mockCreate.call(task, userId)).thenAnswer((_) async {});
    when(mockGetAll.call(userId)).thenAnswer((_) async => [task]);

    final expected = [
      const TaskLoading(status: testStatus),
      const TaskSuccess(status: testStatus),
      const TaskLoading(status: testStatus),
      isA<TaskLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(CreateTaskEvent(task: task, userId: userId));
  });

  test("CreateTaskEvent offline emits TaskNoInternet", () async {
    when(mockCreate.call(task, userId)).thenThrow(
      FirebaseException(code: "unavailable", plugin: "firebase"),
    );

    final expected = [
      const TaskLoading(status: testStatus),
      const TaskNoInternet(status: testStatus),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(CreateTaskEvent(task: task, userId: userId));
  });
}
