import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_app/core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/strings.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_events.dart';
import '../bloc/auth/auth_states.dart';
import '../cubit/password_visibility_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthBloc>().add(
      SignInRequested(
        emailController.text.trim(),
        passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: DetailText(label: Strings.loginText,)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: DetailText(label: state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                ),
                const SizedBox(height: 16),
                BlocBuilder<PasswordVisibilityCubit, bool>(
                  builder: (context, obscure) {
                    return CustomTextField(
                      controller: passwordController,
                      label: "Password",
                      obscure: obscure,
                      suffix: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onSuffixTap: () =>
                          context.read<PasswordVisibilityCubit>().toggle(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _login,
                  child: DetailText(label: Strings.loginText),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
