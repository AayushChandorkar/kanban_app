import '../../entities/auth_entity.dart';
import '../../repository/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repo;

  CheckAuthStatusUseCase(this.repo);

  AuthUser? call() {
    return repo.currentUser();
  }
}
