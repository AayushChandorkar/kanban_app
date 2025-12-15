import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/data/datasource/remote/auth_local_data_source.dart';
import 'package:kanban_app/features/auth/data/model/auth_model.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    dataSource = AuthRemoteDataSourceImpl(mockFirebaseAuth);
  });

  test('signIn should return AuthUserModel on success', () async {
    when(mockUser.uid).thenReturn("123");
    when(mockUser.email).thenReturn("test@mail.com");

    when(mockUserCredential.user).thenReturn(mockUser);
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed("email"),
        password: anyNamed("password"),
      ),
    ).thenAnswer((_) async => mockUserCredential);

    final result = await dataSource.signIn("test@mail.com", "123456");

    expect(result, isA<AuthUserModel>());
    expect(result.id, "123");
  });

  test('currentUser returns null when no user', () {
    when(mockFirebaseAuth.currentUser).thenReturn(null);

    final result = dataSource.currentUser();

    expect(result, null);
  });

  test('currentUser returns AuthUserModel when user exists', () {
    when(mockUser.uid).thenReturn("abc");
    when(mockUser.email).thenReturn("x@y.com");
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

    final result = dataSource.currentUser();

    expect(result!.id, "abc");
  });
}
