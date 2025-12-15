import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/create_user_usecase.dart';
import 'package:kanban_app/features/auth/domain/entities/user_entity.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockUserRepository mockRepo;
  late CreateUserUseCase usecase;

  setUp(() {
    mockRepo = MockUserRepository();
    usecase = CreateUserUseCase(mockRepo);
  });

  test('should call repository.createUser', () async {
    final user = AppUser(id: '1', email: 'a@a.com', name: 'A', createdAt: DateTime.now());

    when(mockRepo.createUser(user)).thenAnswer((_) async => {});

    await usecase(user);

    verify(mockRepo.createUser(user));
    verifyNoMoreInteractions(mockRepo);
  });
}
