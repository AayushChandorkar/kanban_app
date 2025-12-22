import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/strings.dart';
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
        title: Padding(
          padding: EdgeInsets.only(top: 50),
          child: const DetailText(label:  Strings.taskDetailsText),
        ),
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
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailText(label: Strings.titleText, value: task.title),
          DetailText(label: Strings.descriptionText, value: task.description),
          DetailText(label: Strings.statusText, value: task.status),
          DetailText(label: Strings.createdAtText, value: task.createdAt.toString()),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const DetailText(label:  Strings.deleteTaskText),
        content: const DetailText(label:  Strings.deleteConfirmationText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const DetailText(label:  Strings.cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(id: task.id, userId: userId));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const DetailText(label:  Strings.deleteText),
          ),
        ],
      ),
    );
  }
}
