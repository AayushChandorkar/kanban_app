import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/data/datasource/remote/auth_local_data_source.dart';
import '../features/auth/data/datasource/remote/user_local_data_source.dart';
import '../features/auth/data/repository_impl/user_repository_impl.dart';
import '../features/auth/domain/repository/user_repository.dart';
import '../features/auth/domain/usecases/auth/check_status_usecase.dart';
import '../features/auth/domain/usecases/user/create_user_usecase.dart';
import '../features/auth/domain/usecases/user/delete_user_usecase.dart';
import '../features/auth/domain/usecases/user/get_user_usecase.dart';
import '../features/auth/domain/usecases/user/update_user_usecase.dart';

import '../features/auth/data/repository_impl/auth_repository_impl.dart';
import '../features/auth/domain/repository/auth_repository.dart';
import '../features/auth/domain/usecases/auth/sign_in_usecase.dart';
import '../features/auth/domain/usecases/auth/sign_up_usecase.dart';
import '../features/auth/domain/usecases/auth/sign_out_usecase.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../features/auth/presentation/bloc/user/user_bloc.dart';
import '../features/tasks/data/datasource/local/task_database.dart';
import '../features/tasks/data/datasource/local/task_local_data_source.dart';
import '../features/tasks/data/datasource/remote/task_data_source.dart';
import '../features/tasks/data/repository_impl/task_repository_impl.dart';
import '../features/tasks/domain/repository/task_repository.dart';
import '../features/tasks/domain/usecases/create_task_usecase.dart';
import '../features/tasks/domain/usecases/delete_task_usecase.dart';
import '../features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import '../features/tasks/domain/usecases/get_task_usecase.dart';
import '../features/tasks/domain/usecases/update_task_usecase.dart';
import '../features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));

  sl.registerFactory(
    () => UserBloc(
      createUserUseCase: sl(),
      getUserUseCase: sl(),
      updateUserUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => TaskDriftDatabase());

  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sl<TaskDriftDatabase>()),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));

  sl.registerFactory(
    () => TaskBloc(
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      getAllTasks: sl(),
    ),
  );
}
