import '../../domain/entities/task_entity.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {
  final String userId;
  LoadTasks({required this.userId});
}

class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;
  final String userId;
  CreateTaskEvent({required this.task, required this.userId});
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  final String userId;
  UpdateTaskEvent({required this.task, required this.userId});
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  final String userId;
  DeleteTaskEvent({required this.id, required this.userId});
}

class TaskStatusChanged extends TaskEvent {
  final String status;
  TaskStatusChanged(this.status);
}

