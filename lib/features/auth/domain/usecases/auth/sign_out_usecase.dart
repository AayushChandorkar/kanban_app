import '../../repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repo;

  SignOutUseCase(this.repo);

  Future<void> call() {
    return repo.signOut();
  }
}
