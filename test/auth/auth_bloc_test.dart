import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/features/auth/domain/usecases/auth/check_status_usecase.dart';
import 'package:kanban_app/features/auth/domain/usecases/auth/sign_in_usecase.dart';
import 'package:kanban_app/features/auth/domain/usecases/auth/sign_out_usecase.dart';
import 'package:kanban_app/features/auth/domain/usecases/auth/sign_up_usecase.dart';
import 'package:kanban_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:kanban_app/features/auth/presentation/bloc/auth/auth_events.dart';
import 'package:kanban_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban_app/features/auth/data/model/auth_model.dart';

import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  late AuthBloc bloc;

  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late SignOutUseCase signOutUseCase;
  late CheckAuthStatusUseCase checkStatusUseCase;

  setUp(() {
    mockRepo = MockAuthRepository();

    signInUseCase = SignInUseCase(mockRepo);
    signUpUseCase = SignUpUseCase(mockRepo);
    signOutUseCase = SignOutUseCase(mockRepo);
    checkStatusUseCase = CheckAuthStatusUseCase(mockRepo);

    bloc = AuthBloc(
      signInUseCase: signInUseCase,
      signUpUseCase: signUpUseCase,
      signOutUseCase: signOutUseCase,
      checkAuthStatusUseCase: checkStatusUseCase,
    );
  });

  test('CheckAuth emits AuthAuthenticated when user exists', () {
    final user = AuthUserModel(id: "1", email: "x@y.com");

    when(mockRepo.currentUser()).thenReturn(user);

    bloc.add(AuthCheckRequested());

    expectLater(bloc.stream, emitsInOrder([isA<AuthAuthenticated>()]));
  });

  test('SignIn success', () async {
    final user = AuthUserModel(id: "1", email: "x@y.com");

    when(mockRepo.signIn(any, any)).thenAnswer((_) async => user);

    bloc.add(SignInRequested("x@y.com", "123"));

    expectLater(
      bloc.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
    );
  });

  test('SignIn no internet', () async {
    when(
      mockRepo.signIn(any, any),
    ).thenThrow(FirebaseAuthException(code: "network-request-failed"));

    bloc.add(SignInRequested("a", "b"));

    expectLater(
      bloc.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthNoInternet>()]),
    );
  });

  test('SignOut success', () async {
    when(mockRepo.signOut()).thenAnswer((_) async {});

    bloc.add(SignOutRequested());

    expectLater(bloc.stream, emits(isA<AuthUnauthenticated>()));
  });
}
