import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_events.dart';
import '../bloc/task_states.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String status = "todo";
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task created successfully")),
          );
          Navigator.pop(context);
        }


        if (state is TaskNoInternet) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("No Internet"),
              content: const Text(
                "Please check your connection and try again.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    final userId = FirebaseAuth.instance.currentUser!.uid;

                    final task = TaskEntity(
                      id: uuid.v4(),
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      status: status,
                      createdAt: DateTime.now(),
                      userId: userId,
                    );

                    context.read<TaskBloc>().add(
                      CreateTaskEvent(task: task, userId: userId),
                    );
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (state is TaskError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Task")),
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

                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "todo", child: Text("To Do")),
                    DropdownMenuItem(
                      value: "in_progress",
                      child: Text("In Progress"),
                    ),
                    DropdownMenuItem(value: "done", child: Text("Done")),
                  ],
                  onChanged: (val) {
                    setState(() => status = val!);
                  },
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

                        final userId = FirebaseAuth.instance.currentUser!.uid;

                        final task = TaskEntity(
                          id: uuid.v4(),
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          status: status,
                          createdAt: DateTime.now(),
                          userId: userId,
                        );

                        context.read<TaskBloc>().add(
                          CreateTaskEvent(task: task, userId: userId),
                        );
                      },

                      child: const Text("Create Task"),
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
