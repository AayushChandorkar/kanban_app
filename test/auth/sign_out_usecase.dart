import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/domain/usecases/auth/sign_out_usecase.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late SignOutUseCase usecase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = SignOutUseCase(mockRepo);
  });

  test('should call repository.signOut', () async {
    when(mockRepo.signOut()).thenAnswer((_) async => Future.value());

    await usecase();

    verify(mockRepo.signOut()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
