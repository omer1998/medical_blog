import 'package:get_it/get_it.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medical_blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final getIt = GetIt.instance;
Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonKey);

  getIt.registerLazySingleton(() => supabase.client);

  initAuth();
}

void initAuth() {
  getIt.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: getIt()));
  getIt.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: getIt()));
  getIt.registerFactory<SignUpUseCase>(
      () => SignUpUseCase(authRepository: getIt()));

  getIt.registerFactory<SignInUseCase>(
      () => SignInUseCase(authRepository: getIt()));

  getIt.registerFactory<UserStateUseCase>(
      () => UserStateUseCase(authRepository: getIt()));

  getIt.registerLazySingleton(() => AppUserCubit());
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(
      signUpUseCase: getIt(),
      signInUseCase: getIt(),
      userStateUseCase: getIt(),
      appUserCubit: getIt()));
}
