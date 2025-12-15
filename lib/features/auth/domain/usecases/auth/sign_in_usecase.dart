import '../../entities/auth_entity.dart';
import '../../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repo;

  SignInUseCase(this.repo);

  Future<AuthUser> call(String email, String password) {
    return repo.signIn(email, password);
  }
}
