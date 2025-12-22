import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/internet_guard.dart';
import '../../../tasks/presentation/screens/dashboard_page.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_states.dart';
import '../cubit/password_visibility_cubit.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return const DashboardPage();
        }

        if (state is AuthUnauthenticated) {
          return BlocProvider(
            create: (_) => PasswordVisibilityCubit(),
            child: InternetGuard(child: LoginPage()),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
