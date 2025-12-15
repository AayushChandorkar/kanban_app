import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban_app/features/auth/data/datasource/remote/user_local_data_source.dart';
import 'package:kanban_app/features/auth/domain/entities/user_entity.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;

  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocRef);

    dataSource = UserRemoteDataSourceImpl(mockFirestore);
  });

  test('createUser works', () async {
    final user = AppUser(id: "1", email: "a@a.com", name: "A", createdAt: DateTime.now());

    when(mockDocRef.set(any)).thenAnswer((_) async => {});

    await dataSource.createUser(user);

    verify(mockDocRef.set(any));
  });

  test('getUser returns user', () async {
    when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
    when(mockDocSnapshot.exists).thenReturn(true);
    when(mockDocSnapshot.data()).thenReturn({
      "id": "1",
      "email": "a@a.com",
      "name": "A",
      "createdAt": DateTime.now().toIso8601String(),
    });

    final result = await dataSource.getUser("1");

    expect(result, isA<AppUser>());
  });

  test('deleteUser works', () async {
    when(mockDocRef.delete()).thenAnswer((_) async => {});

    await dataSource.deleteUser("1");

    verify(mockDocRef.delete());
  });
}
