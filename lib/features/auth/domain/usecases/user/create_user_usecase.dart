
import '../../entities/user_entity.dart';
import '../../repository/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<void> call(AppUser user) {
    return repository.createUser(user);
  }
}
