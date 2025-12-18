import 'package:kanban_app/features/auth/domain/entities/auth_entity.dart';

abstract class AuthState {
  final bool obscurePassword;
  const AuthState({this.obscurePassword = true});
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(obscurePassword: true);
}

class AuthLoading extends AuthState {
  const AuthLoading({required bool obscure})
      : super(obscurePassword: obscure);
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user, {required bool obscure})
      : super(obscurePassword: obscure);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({required bool obscure})
      : super(obscurePassword: obscure);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message, {required bool obscure})
      : super(obscurePassword: obscure);
}

class AuthNoInternet extends AuthState {
  const AuthNoInternet({required bool obscure})
      : super(obscurePassword: obscure);
}
