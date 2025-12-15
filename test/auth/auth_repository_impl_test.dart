import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/data/model/auth_model.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late AuthRepositoryImpl repo;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    repo = AuthRepositoryImpl(mockRemote);
  });

  test('signIn proxies to remote', () async {
    final user = AuthUserModel(id: "1", email: "a@b.com");

    when(mockRemote.signIn(any, any)).thenAnswer((_) async => user);

    final result = await repo.signIn("a@b.com", "123");

    expect(result.id, "1");
  });

  test('currentUser returns remote current user', () {
    when(
      mockRemote.currentUser(),
    ).thenReturn(AuthUserModel(id: "u1", email: "email"));

    final result = repo.currentUser();

    expect(result!.id, "u1");
  });
}
