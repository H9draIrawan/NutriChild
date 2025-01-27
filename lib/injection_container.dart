import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:nutrichild/data/datasources/remote/auth_remote_data_source.dart';
import 'package:nutrichild/data/repositories/auth_repository_impl.dart';
import 'package:nutrichild/domain/repositories/auth_repository.dart';
import 'package:nutrichild/domain/usecases/auth/login.dart';
import 'package:nutrichild/domain/usecases/auth/register.dart';
import 'package:nutrichild/domain/usecases/auth/logout.dart';
import 'package:nutrichild/domain/usecases/auth/reset_password.dart';
import 'package:nutrichild/domain/usecases/auth/change_password.dart';
import 'package:nutrichild/domain/usecases/auth/delete_account.dart';
import 'package:nutrichild/domain/usecases/auth/update_user.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => DeleteAccount(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      register: sl(),
      logout: sl(),
      resetPassword: sl(),
      changePassword: sl(),
      deleteAccount: sl(),
      updateUser: sl(),
    ),
  );
}
