import '../../domain/entities/user_entity.dart';
import '../../domain/repository/user_repository.dart';
import '../datasource/remote/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createUser(AppUser user) {
    return remoteDataSource.createUser(user);
  }

  @override
  Future<AppUser?> getUser(String id) {
    return remoteDataSource.getUser(id);
  }

  @override
  Future<void> updateUser(AppUser user) {
    return remoteDataSource.updateUser(user);
  }

  @override
  Future<void> deleteUser(String id) {
    return remoteDataSource.deleteUser(id);
  }
}
