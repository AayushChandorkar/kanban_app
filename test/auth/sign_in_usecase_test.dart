import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/domain/usecases/auth/sign_in_usecase.dart';
import 'package:kanban_app/features/auth/data/model/auth_model.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late SignInUseCase usecase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = SignInUseCase(mockRepo);
  });

  test('should call repository signIn', () async {
    final user = AuthUserModel(id: "11", email: "a@b.com");

    when(mockRepo.signIn(any, any)).thenAnswer((_) async => user);

    final result = await usecase("a@b.com", "123");

    expect(result.id, "11");
    verify(mockRepo.signIn("a@b.com", "123"));
  });
}
