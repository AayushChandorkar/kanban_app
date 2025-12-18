import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection/di.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_events.dart';
import '../bloc/auth/auth_states.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_events.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              final user = AppUser(
                id: state.user.id,
                email: state.user.email,
                name:
                "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                createdAt: DateTime.now(),
              );

              context.read<UserBloc>().add(CreateUserEvent(user));
              Navigator.pushReplacementNamed(context, "/dashboard");
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return TextField(
                      controller: passwordController,
                      obscureText: state.obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(TogglePasswordVisibility());
                          },
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          SignUpRequested(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        );
                      },
                      child: const Text("Register"),
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
