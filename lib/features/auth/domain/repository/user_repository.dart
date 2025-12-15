import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(AppUser user);
  Future<AppUser?> getUser(String id);
  Future<void> updateUser(AppUser user);
  Future<void> deleteUser(String id);
}
