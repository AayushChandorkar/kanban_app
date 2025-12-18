import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_events.dart';
import '../bloc/task_states.dart';

class EditTaskPage extends StatelessWidget {
  final TaskEntity task;

  EditTaskPage({super.key, required this.task});

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleController =
  TextEditingController(text: task.title);
  late final TextEditingController descriptionController =
  TextEditingController(text: task.description);

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(TaskStatusChanged(task.status));

    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task updated successfully")),
          );
          Navigator.pop(context);
        }

        if (state is TaskNoInternet) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("No Internet"),
              content:
              const Text("Please check your connection and try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateTask(context, state.status);
                  },
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Task"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<TaskBloc>().add(
                  DeleteTaskEvent(id: task.id, userId: userId),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty ? "Title is required" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return DropdownButtonFormField<String>(
                      value: state.status,
                      decoration: const InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "todo",
                          child: Text("To Do"),
                        ),
                        DropdownMenuItem(
                          value: "in_progress",
                          child: Text("In Progress"),
                        ),
                        DropdownMenuItem(
                          value: "done",
                          child: Text("Done"),
                        ),
                      ],
                      onChanged: (val) {
                        context
                            .read<TaskBloc>()
                            .add(TaskStatusChanged(val!));
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        _updateTask(context, state.status);
                      },
                      child: const Text("Update Task"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateTask(BuildContext context, String status) {
    final updatedTask = TaskEntity(
      id: task.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      status: status,
      createdAt: task.createdAt,
      userId: userId,
    );

    context.read<TaskBloc>().add(
      UpdateTaskEvent(task: updatedTask, userId: userId),
    );
  }
}
