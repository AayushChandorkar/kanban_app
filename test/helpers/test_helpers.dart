import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kanban_app/features/auth/data/datasource/remote/auth_local_data_source.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/create_user_usecase.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/delete_user_usecase.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/get_user_usecase.dart';
import 'package:kanban_app/features/auth/domain/usecases/user/update_user_usecase.dart';
import 'package:kanban_app/features/tasks/data/datasource/local/task_database.dart';
import 'package:kanban_app/features/tasks/data/datasource/local/task_local_data_source.dart';
import 'package:kanban_app/features/tasks/data/datasource/remote/task_data_source.dart';
import 'package:kanban_app/features/tasks/domain/repository/task_repository.dart';
import 'package:kanban_app/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:kanban_app/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:kanban_app/features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:kanban_app/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban_app/features/auth/data/datasource/remote/user_local_data_source.dart';
import 'package:kanban_app/features/auth/domain/repository/auth_repository.dart';
import 'package:kanban_app/features/auth/domain/repository/user_repository.dart';


@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  AuthRemoteDataSource,
  AuthRepository,
  UserRemoteDataSource,
  UserRepository,
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
  GetUserUseCase,
  UpdateUserUseCase,
  DeleteUserUseCase,
  CreateUserUseCase,
  QuerySnapshot,
  Query,
  TaskRemoteDataSource,
  TaskLocalDataSource,
  TaskRepository,
  TaskDriftDatabase,
  CreateTaskUseCase,
  UpdateTaskUseCase,
  DeleteTaskUseCase,
  GetAllTasksUseCase,
  Connectivity,
])
void main() {}
