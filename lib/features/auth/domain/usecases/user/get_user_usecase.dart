import '../../entities/user_entity.dart';
import '../../repository/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<AppUser?> call(String id) {
    return repository.getUser(id);
  }
}
