import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_all_tasks_usecase.dart';
import 'task_events.dart';
import 'task_states.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTaskUseCase createTask;
  final UpdateTaskUseCase updateTask;
  final DeleteTaskUseCase deleteTask;
  final GetAllTasksUseCase getAllTasks;

  TaskBloc({
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getAllTasks,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_loadTasks);
    on<CreateTaskEvent>(_createTask);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTaskEvent>(_deleteTask);
  }

  Future<void> _loadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasks.call(event.userId);
      emit(TaskLoaded(tasks));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet());
      } else {
        emit(TaskError(e.message ?? "Authentication error"));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _createTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await createTask.call(event.task, event.userId);

      emit(TaskSuccess());

      add(LoadTasks(userId: event.userId));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet());
      } else {
        emit(TaskError(e.message ?? "Authentication error"));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _updateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await updateTask.call(event.task, event.userId);

      emit(TaskSuccess());

      final tasks = await getAllTasks(event.userId);
      emit(TaskLoaded(tasks));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet());
      } else {
        emit(TaskError(e.message ?? "Authentication error"));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _deleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await deleteTask.call(event.id, event.userId);

      final tasks = await getAllTasks(event.userId);
      emit(TaskLoaded(tasks));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet());
      } else {
        emit(TaskError(e.message ?? "Authentication error"));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
