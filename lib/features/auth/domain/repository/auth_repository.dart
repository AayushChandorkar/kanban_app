import '../entities/auth_entity.dart';

abstract class AuthRepository {

  Future<AuthUser> signIn(String email, String password);

  Future<AuthUser> signUp(String email, String password);

  Future<void> signOut();

  AuthUser? currentUser();

}
