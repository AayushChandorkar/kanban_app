import '../../domain/entities/task_entity.dart';

abstract class TaskState {
  final String status;
  const TaskState({this.status = "todo"});
}
class TaskInitial extends TaskState {
  const TaskInitial() : super(status: "todo");
}

class TaskLoading extends TaskState {
  const TaskLoading({required String status}) : super(status: status);
}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  const TaskLoaded(this.tasks, {required String status})
      : super(status: status);
}

class TaskSuccess extends TaskState {
  const TaskSuccess({required String status}) : super(status: status);
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message, {required String status})
      : super(status: status);
}

class TaskNoInternet extends TaskState {
  const TaskNoInternet({required String status}) : super(status: status);
}
