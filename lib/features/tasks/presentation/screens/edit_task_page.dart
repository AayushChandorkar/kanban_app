import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_app/core/utils/custom_text.dart';

import '../../../../core/utils/custom_dropdown_field.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../../../core/utils/strings.dart';
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
            SnackBar(content: DetailText(label:  Strings.taskUpdatedSuccessfullyText)),
          );
          Navigator.pop(context);
        }

        if (state is TaskNoInternet) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: DetailText(label:  Strings.noInternetText),
              content:
              DetailText(label: Strings.checkYourConnectionText),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateTask(context, state.status);
                  },
                  child: const DetailText(label:  Strings.retryText),
                )
              ],
            ),
          );
        }

        if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: DetailText(label:  state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: DetailText(label:  Strings.editTaskText),
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
                CustomFormField(
                  controller: titleController,
                  label: "Title",
                  validator: (v) =>
                  v == null || v.isEmpty ? "Title is required" : null,
                ),
                const SizedBox(height: 16),

                CustomFormField(
                  controller: descriptionController,
                  label: "Description",
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return CustomDropdownField(
                      value: state.status,
                      label: "Status",
                      items: const [
                        DropdownMenuItem(
                          value: "todo",
                          child: DetailText(label:  Strings.todoText),
                        ),
                        DropdownMenuItem(
                          value: "in_progress",
                          child: DetailText(label:  Strings.inProgressText),
                        ),
                        DropdownMenuItem(
                          value: "done",
                          child: DetailText(label:  Strings.doneText),
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
                      child: const DetailText(label:  Strings.updateText),
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
