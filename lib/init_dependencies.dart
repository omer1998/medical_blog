import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';
import 'package:medical_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medical_blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/blog/data/datasources/local_data_source.dart';
import 'package:medical_blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:medical_blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:medical_blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/fetch_blogs_usecase.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final getIt = GetIt.instance;
Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonKey);

  getIt.registerLazySingleton(() => supabase.client);
  getIt.registerFactory(() => InternetConnection());
  getIt.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(internetConnection: getIt()));

  await Hive.initFlutter();
  final blogsBox = await Hive.openBox("blogs");
  getIt.registerLazySingleton<Box>(() => blogsBox);

  initAuth();
  initBlogs();
}

void initAuth() {
  getIt.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: getIt()));
  getIt.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
      authRemoteDataSource: getIt(), connectionChecker: getIt()));
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

initBlogs() {
  getIt
    ..registerFactory<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(supabaseClient: getIt()))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(box: getIt()))
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
        blogRemoteDataSource: getIt(),
        connectionChecker: getIt(),
        blogLocalDataSource: getIt()))
    ..registerFactory<FetchBlogsUseCase>(
        () => FetchBlogsUseCase(blogRepository: getIt()))
    ..registerFactory<UploadBlogUseCase>(
        () => UploadBlogUseCase(blogRepository: getIt()))
    ..registerLazySingleton<BlogBloc>(
        () => BlogBloc(fetchBlogsUseCase: getIt(), uploadBlogUseCase: getIt()));
}
