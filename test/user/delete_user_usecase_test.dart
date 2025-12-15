import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/delete_user_usecase.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockUserRepository mockRepo;
  late DeleteUserUseCase usecase;

  setUp(() {
    mockRepo = MockUserRepository();
    usecase = DeleteUserUseCase(mockRepo);
  });

  test('should call repository.deleteUser', () async {
    when(mockRepo.deleteUser('1')).thenAnswer((_) async => {});

    await usecase('1');

    verify(mockRepo.deleteUser('1'));
  });
}