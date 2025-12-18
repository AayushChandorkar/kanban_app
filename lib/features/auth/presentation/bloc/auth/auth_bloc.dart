import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/check_status_usecase.dart';
import '../../../domain/usecases/auth/sign_in_usecase.dart';
import '../../../domain/usecases/auth/sign_out_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckAuth);
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onCheckAuth(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = checkAuthStatusUseCase();
    user != null
        ? emit(AuthAuthenticated(user))
        : emit(AuthUnauthenticated());
  }

  Future<void> _onSignIn(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(event.email, event.password);
      emit(AuthAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        emit(const AuthNoInternet());
      } else {
        emit(AuthError(e.message ?? "Authentication error"));
      }
    }
  }

  Future<void> _onSignUp(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await signUpUseCase(event.email, event.password);
    emit(AuthAuthenticated(user));
  }

  Future<void> _onSignOut(
      SignOutRequested event, Emitter<AuthState> emit) async {
    await signOutUseCase();
    emit(const AuthUnauthenticated());
  }
}
