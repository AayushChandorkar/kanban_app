import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_app/features/auth/presentation/screens/register_page.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_events.dart';
import '../bloc/auth/auth_states.dart';
import '../cubit/password_visibility_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }

          if (state is AuthNoInternet) {
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
                      context.read<AuthBloc>().add(
                        SignInRequested(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                      );
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              BlocBuilder<PasswordVisibilityCubit, bool>(
                builder: (context, obscure) {
                  return TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          context
                              .read<PasswordVisibilityCubit>()
                              .toggle();
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
                        SignInRequested(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                      );
                    },
                    child: const Text("Login"),
                  );
                },
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
