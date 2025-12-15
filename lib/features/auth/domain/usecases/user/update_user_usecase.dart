import '../../entities/user_entity.dart';
import '../../repository/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call(AppUser user) {
    return repository.updateUser(user);
  }
}
