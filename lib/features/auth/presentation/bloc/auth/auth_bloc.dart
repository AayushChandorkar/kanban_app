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

  bool _obscure = true;

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
    on<TogglePasswordVisibility>(_onTogglePassword);
  }

  void _onTogglePassword(
      TogglePasswordVisibility event,
      Emitter<AuthState> emit,
      ) {
    _obscure = !_obscure;
    emit(AuthUnauthenticated(obscure: _obscure));
  }

  Future<void> _onCheckAuth(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = checkAuthStatusUseCase();
    if (user != null) {
      emit(AuthAuthenticated(user, obscure: _obscure));
    } else {
      emit(AuthUnauthenticated(obscure: _obscure));
    }
  }

  Future<void> _onSignIn(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(obscure: _obscure));
    try {
      final user = await signInUseCase(event.email, event.password);
      emit(AuthAuthenticated(user, obscure: _obscure));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        emit(AuthNoInternet(obscure: _obscure));
      } else {
        emit(AuthError(e.message ?? "Authentication error",
            obscure: _obscure));
      }
    }
  }

  Future<void> _onSignUp(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(obscure: _obscure));
    final user = await signUpUseCase(event.email, event.password);
    emit(AuthAuthenticated(user, obscure: _obscure));
  }

  Future<void> _onSignOut(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await signOutUseCase();
    emit(AuthUnauthenticated(obscure: _obscure));
  }
}
