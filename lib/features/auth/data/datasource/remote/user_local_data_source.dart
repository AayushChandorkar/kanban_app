import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user_entity.dart';
import '../../model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<void> createUser(AppUser user);

  Future<AppUser?> getUser(String id);

  Future<void> updateUser(AppUser user);

  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createUser(AppUser user) async {
    final model = AppUserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
    );

    await firestore.collection('users').doc(user.id).set(model.toFirestore());
  }

  @override
  Future<AppUser?> getUser(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    if (!doc.exists) return null;

    return AppUserModel.fromDocument(doc);
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final model = AppUserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
    );

    await firestore
        .collection('users')
        .doc(user.id)
        .update(model.toFirestore());
  }

  @override
  Future<void> deleteUser(String id) async {
    await firestore.collection('users').doc(id).delete();
  }
}
