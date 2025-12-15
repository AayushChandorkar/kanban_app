import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/get_user_usecase.dart';
import 'package:kanban_app/features/auth/domain/entities/user_entity.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockUserRepository mockRepo;
  late GetUserUseCase usecase;

  setUp(() {
    mockRepo = MockUserRepository();
    usecase = GetUserUseCase(mockRepo);
  });

  test('should return user from repository', () async {
    final user = AppUser(id: '1', email: 'a@a.com', name: 'A', createdAt: DateTime.now());

    when(mockRepo.getUser('1')).thenAnswer((_) async => user);

    final result = await usecase('1');

    expect(result, user);
    verify(mockRepo.getUser('1'));
  });
}
