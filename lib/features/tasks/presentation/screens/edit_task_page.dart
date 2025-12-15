import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_events.dart';
import '../bloc/task_states.dart';

class EditTaskPage extends StatefulWidget {
  final TaskEntity task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late String status;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    status = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
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
              content: const Text("Please check your connection and try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    final updatedTask = TaskEntity(
                      id: widget.task.id,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      status: status,
                      createdAt: widget.task.createdAt,
                      userId: userId,
                    );

                    context.read<TaskBloc>().add(
                      UpdateTaskEvent(task: updatedTask, userId: userId),
                    );
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
                  DeleteTaskEvent(id: widget.task.id, userId: userId),
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
                  validator: (v) => v == null || v.isEmpty ? "Title is required" : null,
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

                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "todo", child: Text("To Do")),
                    DropdownMenuItem(value: "in_progress", child: Text("In Progress")),
                    DropdownMenuItem(value: "done", child: Text("Done")),
                  ],
                  onChanged: (val) => setState(() => status = val!),
                ),
                const SizedBox(height: 24),

                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        final updatedTask = TaskEntity(
                          id: widget.task.id,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          status: status,
                          createdAt: widget.task.createdAt,
                          userId: userId,
                        );

                        context.read<TaskBloc>().add(
                          UpdateTaskEvent(task: updatedTask, userId: userId),
                        );
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
}
