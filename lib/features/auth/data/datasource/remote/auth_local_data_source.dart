import 'package:firebase_auth/firebase_auth.dart';

import '../../model/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> signIn(String email, String password);
  Future<AuthUserModel> signUp(String email, String password);
  Future<void> signOut();
  AuthUserModel? currentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl(this.auth);

  @override
  Future<AuthUserModel> signIn(String email, String password) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AuthUserModel.fromFirebaseUser(result.user!);
  }

  @override
  Future<AuthUserModel> signUp(String email, String password) async {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AuthUserModel.fromFirebaseUser(result.user!);
  }

  @override
  Future<void> signOut() => auth.signOut();

  @override
  AuthUserModel? currentUser() {
    final user = auth.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromFirebaseUser(user);
  }
}
