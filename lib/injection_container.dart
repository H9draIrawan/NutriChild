import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:nutrichild/data/datasources/remote/auth_remote_data_source.dart';
import 'package:nutrichild/data/datasources/remote/child_remote_data_source.dart';
import 'package:nutrichild/data/datasources/remote/meal_remote_data_source.dart';
import 'package:nutrichild/data/repositories/auth_repository_impl.dart';
import 'package:nutrichild/data/repositories/child_repository_impl.dart';
import 'package:nutrichild/data/repositories/meal_repository_impl.dart';
import 'package:nutrichild/domain/repositories/auth_repository.dart';
import 'package:nutrichild/domain/repositories/child_repository.dart';
import 'package:nutrichild/domain/repositories/meal_repository.dart';
import 'package:nutrichild/domain/usecases/auth/login.dart';
import 'package:nutrichild/domain/usecases/auth/register.dart';
import 'package:nutrichild/domain/usecases/auth/logout.dart';
import 'package:nutrichild/domain/usecases/auth/reset_password.dart';
import 'package:nutrichild/domain/usecases/auth/change_password.dart';
import 'package:nutrichild/domain/usecases/auth/delete_account.dart';
import 'package:nutrichild/domain/usecases/auth/update_user.dart';
import 'package:nutrichild/domain/usecases/child/get_child.dart';
import 'package:nutrichild/domain/usecases/child/add_child.dart';
import 'package:nutrichild/domain/usecases/child/update_child.dart';
import 'package:nutrichild/domain/usecases/child/delete_child.dart';
import 'package:nutrichild/domain/usecases/meal/get_meal.dart';
import 'package:nutrichild/domain/usecases/meal/add_meal.dart';
import 'package:nutrichild/domain/usecases/meal/update_meal.dart';
import 'package:nutrichild/domain/usecases/meal/delete_meal.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_bloc.dart';
import 'package:nutrichild/presentation/bloc/child/child_bloc.dart';
import 'package:nutrichild/presentation/bloc/meal/meal_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ChildRepository>(
    () => ChildRepositoryImpl(
      childRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(
      mealRemoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<ChildRemoteDataSource>(
    () => ChildRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(
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
  sl.registerLazySingleton(() => GetChild(sl()));
  sl.registerLazySingleton(() => AddChild(sl()));
  sl.registerLazySingleton(() => UpdateChild(sl()));
  sl.registerLazySingleton(() => DeleteChild(sl()));
  sl.registerLazySingleton(() => GetMeal(sl()));
  sl.registerLazySingleton(() => AddMeal(sl()));
  sl.registerLazySingleton(() => UpdateMeal(sl()));
  sl.registerLazySingleton(() => DeleteMeal(sl()));

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

  sl.registerFactory(
    () => ChildBloc(
      addChild: sl(),
      updateChild: sl(),
      deleteChild: sl(),
      getChild: sl(),
    ),
  );

  sl.registerFactory(
    () => MealBloc(
      getMeal: sl(),
      addMeal: sl(),
      updateMeal: sl(),
      deleteMeal: sl(),
    ),
  );
}
