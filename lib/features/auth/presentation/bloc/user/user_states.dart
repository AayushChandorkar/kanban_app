import '../../../domain/entities/user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final AppUser user;
  UserLoaded(this.user);
}

class UserCreated extends UserState {
  final AppUser user;
  UserCreated(this.user);
}

class UserUpdated extends UserState {
  final AppUser user;
  UserUpdated(this.user);
}

class UserDeleted extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
