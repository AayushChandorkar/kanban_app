import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_app/features/auth/presentation/bloc/user/user_events.dart';
import 'package:kanban_app/features/auth/presentation/bloc/user/user_states.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/create_user_usecase.dart';
import '../../../domain/usecases/user/get_user_usecase.dart';
import '../../../domain/usecases/user/update_user_usecase.dart';
import '../../../domain/usecases/user/delete_user_usecase.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final CreateUserUseCase createUserUseCase;

  UserBloc({
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.createUserUseCase,
  }) : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<LoadUser>(_onLoadUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<ClearUserState>((event, emit) => emit(UserInitial()));
  }

  Future<void> _onCreateUser(
      CreateUserEvent event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());

    try {
      await createUserUseCase(event.user);
      emit(UserCreated(event.user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }


  Future<void> _onLoadUser(
      LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await getUserUseCase(event.userId);
      if (user == null) {
        emit(UserError("User not found"));
        return;
      }
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await updateUserUseCase(event.user);
      emit(UserUpdated(event.user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await deleteUserUseCase(event.userId);
      emit(UserDeleted());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
