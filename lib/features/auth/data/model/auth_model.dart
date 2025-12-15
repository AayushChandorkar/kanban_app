
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_entity.dart';

class AuthUserModel extends AuthUser {
   AuthUserModel({
    required super.id,
    required super.email,
  });

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}