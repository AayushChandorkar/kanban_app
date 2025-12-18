import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_app/core/utils/custom_text.dart';

import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection/di.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_events.dart';
import '../bloc/auth/auth_states.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_events.dart';
import '../cubit/password_visibility_cubit.dart';

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
        BlocProvider(create: (_) => sl<UserBloc>()),
        BlocProvider(create: (_) => PasswordVisibilityCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: DetailText(label: Strings.registerText)),
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
                SnackBar(content: DetailText(label: state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                CustomTextField(
                  controller: firstNameController,
                  label: "First Name",
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: lastNameController,
                  label: "Last Name",
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: emailController,
                  label: "Email ID",
                ),
                const SizedBox(height: 16),

                /// ✅ Password field using Cubit
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
                      child: DetailText(label: Strings.registerText),
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
