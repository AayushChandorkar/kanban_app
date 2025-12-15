import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/auth/data/repository_impl/user_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban_app/features/auth/domain/entities/user_entity.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockUserRemoteDataSource mockDS;
  late UserRepositoryImpl repo;

  setUp(() {
    mockDS = MockUserRemoteDataSource();
    repo = UserRepositoryImpl(mockDS);
  });

  test('createUser calls datasource', () async {
    final user = AppUser(id: '1', email: 'a@a.com', name: 'A', createdAt: DateTime.now());

    when(mockDS.createUser(user)).thenAnswer((_) async => {});

    await repo.createUser(user);

    verify(mockDS.createUser(user));
  });

  test('getUser calls datasource', () async {
    final user = AppUser(id: '1', email: 'a@a.com', name: 'A', createdAt: DateTime.now());

    when(mockDS.getUser('1')).thenAnswer((_) async => user);

    final result = await repo.getUser('1');

    expect(result, user);
    verify(mockDS.getUser('1'));
  });

  test('updateUser calls datasource', () async {
    final user = AppUser(id: '1', email: 'a@a.com', name: 'A', createdAt: DateTime.now());

    when(mockDS.updateUser(user)).thenAnswer((_) async => {});
    await repo.updateUser(user);

    verify(mockDS.updateUser(user));
  });

  test('deleteUser calls datasource', () async {
    when(mockDS.deleteUser('1')).thenAnswer((_) async => {});
    await repo.deleteUser('1');

    verify(mockDS.deleteUser('1'));
  });
}
