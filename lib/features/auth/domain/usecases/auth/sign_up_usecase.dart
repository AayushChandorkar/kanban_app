import '../../entities/auth_entity.dart';
import '../../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repo;

  SignUpUseCase(this.repo);

  Future<AuthUser> call(String email, String password) {
    return repo.signUp(email, password);
  }
}
