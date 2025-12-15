import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/data/datasource/local/task_local_data_source.dart';
import 'package:kanban_app/features/tasks/data/model/task_model.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockTaskDriftDatabase mockDb;
  late TaskLocalDataSourceImpl dataSource;

  setUp(() {
    mockDb = MockTaskDriftDatabase();
    dataSource = TaskLocalDataSourceImpl(mockDb);
  });

  test("cacheTask calls db.upsertTask", () async {
    final model = TaskModel(
      id: "1",
      title: "t",
      description: "d",
      status: "todo",
      userId: "u1",
      createdAt: DateTime.now(),
    );

    when(mockDb.upsertTask(any)).thenAnswer((_) async {});

    await dataSource.cacheTask(model);

    verify(mockDb.upsertTask(any)).called(1);
  });
}
