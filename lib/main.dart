import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/presentation/screens/register_page.dart';
import 'package:kanban_app/features/tasks/presentation/screens/add_task_page.dart';

import 'features/auth/presentation/screens/login_page.dart';
import 'features/tasks/presentation/screens/dashboard_page.dart';
import 'firebase_options.dart';
import 'injection/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/dashboard': (_) => const DashboardPage(),
        '/register': (_) => const RegisterPage(),
        '/addTask': (_) => const AddTaskPage()
      },
    );
  }
}

