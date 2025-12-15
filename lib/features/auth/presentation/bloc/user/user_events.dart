import '../../../domain/entities/user_entity.dart';

abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final AppUser user;
  CreateUserEvent(this.user);
}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

class UpdateUserEvent extends UserEvent {
  final AppUser user;
  UpdateUserEvent(this.user);
}

class DeleteUserEvent extends UserEvent {
  final String userId;
  DeleteUserEvent(this.userId);
}

class ClearUserState extends UserEvent {}
