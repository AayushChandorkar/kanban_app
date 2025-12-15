import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_events.dart';
import '../bloc/task_states.dart';
import 'edit_task_page.dart';

class ViewTaskPage extends StatelessWidget {
  final TaskEntity task;

  const ViewTaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<TaskBloc>(),
                    child: EditTaskPage(task: task),
                  ),
                ),
              );

              context.read<TaskBloc>().add(LoadTasks(userId: userId));
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),

      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          TaskEntity displayed = task;

          if (state is TaskLoaded) {
            displayed = state.tasks.firstWhere(
                  (t) => t.id == task.id,
              orElse: () => task,
            );
          }

          return _buildDetails(context, displayed);
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context, TaskEntity task) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Title", style: Theme.of(context).textTheme.titleLarge),
          Text(task.title),
          const SizedBox(height: 16),

          Text("Description", style: Theme.of(context).textTheme.titleLarge),
          Text(task.description),
          const SizedBox(height: 16),

          Text("Status", style: Theme.of(context).textTheme.titleLarge),
          Text(task.status),
          const SizedBox(height: 16),

          Text("Created At", style: Theme.of(context).textTheme.titleLarge),
          Text(task.createdAt.toString()),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(id: task.id, userId: userId));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
