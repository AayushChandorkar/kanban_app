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

  String _status = "todo";

  TaskBloc({
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getAllTasks,
  }) : super(const TaskInitial()) {
    on<LoadTasks>(_loadTasks);
    on<CreateTaskEvent>(_createTask);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<TaskStatusChanged>(_onStatusChanged);
  }

  void _onStatusChanged(
      TaskStatusChanged event,
      Emitter<TaskState> emit,
      ) {
    _status = event.status;
    emit(TaskInitial());
  }

  Future<void> _loadTasks(
      LoadTasks event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading(status: _status));
    try {
      final tasks = await getAllTasks.call(event.userId);
      emit(TaskLoaded(tasks, status: _status));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet(status: _status));
      } else {
        emit(TaskError(
          e.message ?? "Authentication error",
          status: _status,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString(), status: _status));
    }
  }

  Future<void> _createTask(
      CreateTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading(status: _status));
    try {
      await createTask.call(event.task, event.userId);

      emit(TaskSuccess(status: _status));

      add(LoadTasks(userId: event.userId));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet(status: _status));
      } else {
        emit(TaskError(
          e.message ?? "Authentication error",
          status: _status,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString(), status: _status));
    }
  }

  Future<void> _updateTask(
      UpdateTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading(status: _status));
    try {
      await updateTask.call(event.task, event.userId);

      emit(TaskSuccess(status: _status));

      final tasks = await getAllTasks(event.userId);
      emit(TaskLoaded(tasks, status: _status));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet(status: _status));
      } else {
        emit(TaskError(
          e.message ?? "Authentication error",
          status: _status,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString(), status: _status));
    }
  }

  Future<void> _deleteTask(
      DeleteTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading(status: _status));
    try {
      await deleteTask.call(event.id, event.userId);

      final tasks = await getAllTasks(event.userId);
      emit(TaskLoaded(tasks, status: _status));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        emit(TaskNoInternet(status: _status));
      } else {
        emit(TaskError(
          e.message ?? "Authentication error",
          status: _status,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString(), status: _status));
    }
  }
}
