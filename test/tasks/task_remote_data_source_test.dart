import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/tasks/data/datasource/remote/task_data_source.dart';
import 'package:kanban_app/features/tasks/domain/entities/task_entity.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late TaskRemoteDataSourceImpl dataSource;

  const userId = "user123";

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    dataSource = TaskRemoteDataSourceImpl(mockFirestore);
  });

  group("createTask", () {
    test("should call firestore and set document", () async {
      final task = TaskEntity(
        id: "1",
        title: "title",
        description: "desc",
        status: "todo",
        createdAt: DateTime.now(),
        userId: userId,
      );

      when(mockFirestore.collection("users"))
          .thenReturn(mockCollection);
      when(mockCollection.doc(userId))
          .thenReturn(mockDocRef);
      when(mockDocRef.collection("tasks"))
          .thenReturn(mockCollection);
      when(mockCollection.doc(task.id)).thenReturn(mockDocRef);
      when(mockDocRef.set(any)).thenAnswer((_) async {});

      await dataSource.createTask(task, userId);

      verify(mockDocRef.set(any)).called(1);
    });
  });
}
