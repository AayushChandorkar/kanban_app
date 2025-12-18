import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_app/features/tasks/presentation/screens/view_task_page.dart';

import '../../../../injection/di.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth/auth_events.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_events.dart';
import '../bloc/task_states.dart';
import 'add_task_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (_) => sl<TaskBloc>(),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            context.read<TaskBloc>().add(LoadTasks(userId: userId));

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is TaskLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is TaskError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Dashboard")),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      "Something went wrong",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<TaskBloc>().add(
                        LoadTasks(userId: userId),
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! TaskLoaded) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.tasks.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text("Dashboard")),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "No Tasks Available",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You haven’t created any tasks yet.",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TaskBloc>().add(LoadTasks(userId: userId));
                      },
                      child: const Text("Refresh"),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<TaskBloc>(),
                        child: AddTaskPage(),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          }

          final tasks = state.tasks;

          final todo = tasks.where((t) => t.status == "todo").toList();
          final inProgress = tasks
              .where((t) => t.status == "in_progress")
              .toList();
          final done = tasks.where((t) => t.status == "done").toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Dashboard"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                ),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<TaskBloc>(),
                      child: AddTaskPage(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _kanbanColumn(
                    context,
                    "To Do",
                    todo,
                    Colors.red.shade100,
                    "todo",
                  ),
                  _kanbanColumn(
                    context,
                    "In Progress",
                    inProgress,
                    Colors.yellow.shade100,
                    "in_progress",
                  ),
                  _kanbanColumn(
                    context,
                    "Done",
                    done,
                    Colors.green.shade100,
                    "done",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _kanbanColumn(
    BuildContext context,
    String title,
    List<TaskEntity> tasks,
    Color bg,
    String columnStatus,
  ) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Expanded(
      child: DragTarget<TaskEntity>(
        onWillAccept: (task) {
          if (task == null) return false;
          if (task.status == "done" && columnStatus != "done") return false;
          return true;
        },
        onAccept: (task) {
          if (task.status == columnStatus) return;
          final updatedTask = TaskEntity(
            id: task.id,
            title: task.title,
            description: task.description,
            status: columnStatus,
            createdAt: task.createdAt,
            userId: task.userId,
          );
          context.read<TaskBloc>().add(
            UpdateTaskEvent(task: updatedTask, userId: userId),
          );
        },
        builder: (context, candidate, rejected) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  "$title (${tasks.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: tasks.map((task) {
                      return LongPressDraggable<TaskEntity>(
                        data: task,
                        feedback: Material(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.blue,
                            child: Text(
                              task.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _taskCard(context, task),
                        ),
                        child: _taskCard(context, task),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _taskCard(BuildContext context, TaskEntity task) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: ViewTaskPage(task: task),
              ),
            ),
          );
        },
      ),
    );
  }
}
