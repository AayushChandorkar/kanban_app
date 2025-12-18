  import '../../domain/entities/auth_entity.dart';
  import '../../domain/repository/auth_repository.dart';
  import '../datasource/remote/auth_local_data_source.dart';
  class AuthRepositoryImpl implements AuthRepository {
    final AuthRemoteDataSource remote;

    AuthRepositoryImpl(this.remote);

    @override
    Future<AuthUser> signIn(String email, String password) {
      return remote.signIn(email, password);
    }

    @override
    Future<AuthUser> signUp(String email, String password) {
      return remote.signUp(email, password);
    }

    @override
    Future<void> signOut() {
      return remote.signOut();
    }

    @override
    AuthUser? currentUser() {
      return remote.currentUser();
    }
  }
