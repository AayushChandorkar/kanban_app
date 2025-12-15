import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/domain/usecases/auth/check_status_usecase.dart';
import 'package:kanban_app/features/auth/data/model/auth_model.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late CheckAuthStatusUseCase usecase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = CheckAuthStatusUseCase(mockRepo);
  });

  test('should return current user from repository', () {
    final user = AuthUserModel(id: '101', email: 'check@mail.com');

    when(mockRepo.currentUser()).thenReturn(user);

    final result = usecase();

    expect(result, isA<AuthUserModel>());
    expect(result!.id, '101');

    verify(mockRepo.currentUser()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return null when no user is logged in', () {
    when(mockRepo.currentUser()).thenReturn(null);

    final result = usecase();

    expect(result, null);

    verify(mockRepo.currentUser()).called(1);
  });
}
