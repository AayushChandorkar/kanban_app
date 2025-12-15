import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanban_app/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:kanban_app/features/auth/presentation/bloc/user/user_events.dart';
import 'package:kanban_app/features/auth/presentation/bloc/user/user_states.dart';
import 'package:kanban_app/features/auth/domain/entities/user_entity.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockGetUserUseCase mockGetUser;
  late MockUpdateUserUseCase mockUpdateUser;
  late MockDeleteUserUseCase mockDeleteUser;
  late MockCreateUserUseCase mockCreateUser;
  late UserBloc bloc;

  setUp(() {
    mockGetUser = MockGetUserUseCase();
    mockUpdateUser = MockUpdateUserUseCase();
    mockDeleteUser = MockDeleteUserUseCase();
    mockCreateUser = MockCreateUserUseCase();

    bloc = UserBloc(
      getUserUseCase: mockGetUser,
      updateUserUseCase: mockUpdateUser,
      deleteUserUseCase: mockDeleteUser,
      createUserUseCase: mockCreateUser,
    );
  });

  final user = AppUser(
    id: '1',
    email: 'a@a.com',
    name: 'A',
    createdAt: DateTime.now(),
  );

  test('Create user success', () {
    when(mockCreateUser(user)).thenAnswer((_) async => {});

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<UserLoading>(),
        isA<UserCreated>(),
      ]),
    );

    bloc.add(CreateUserEvent(user));
  });

  test('Load user success', () {
    when(mockGetUser('1')).thenAnswer((_) async => user);

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<UserLoading>(),
        isA<UserLoaded>(),
      ]),
    );

    bloc.add(LoadUser('1'));
  });

  test('Update user success', () {
    when(mockUpdateUser(user)).thenAnswer((_) async => {});

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<UserLoading>(),
        isA<UserUpdated>(),
      ]),
    );

    bloc.add(UpdateUserEvent(user));
  });

  test('Delete user success', () {
    when(mockDeleteUser('1')).thenAnswer((_) async => {});

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<UserLoading>(),
        isA<UserDeleted>(),
      ]),
    );

    bloc.add(DeleteUserEvent('1'));
  });
}
