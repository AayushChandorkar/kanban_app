import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/domain/usecases/auth/sign_up_usecase.dart';
import 'package:kanban_app/features/auth/data/model/auth_model.dart';

import '../helpers/test_helpers.mocks.dart';


void main() {
  late SignUpUseCase usecase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = SignUpUseCase(mockRepo);
  });

  test('should call repository.signUp and return AuthUser', () async {
    final user = AuthUserModel(id: '42', email: 'test@mail.com');

    when(mockRepo.signUp(any, any)).thenAnswer((_) async => user);

    final result = await usecase('test@mail.com', 'password');

    expect(result, isA<AuthUserModel>());
    expect(result.id, '42');

    verify(mockRepo.signUp('test@mail.com', 'password')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
