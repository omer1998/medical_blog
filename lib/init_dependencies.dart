import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';
import 'package:medical_blog_app/core/profile_local_datasource.dart';
import 'package:medical_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medical_blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/blog/data/datasources/local_data_source.dart';
import 'package:medical_blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:medical_blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:medical_blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/fav_blog_usecase.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/fetch_blogs_usecase.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final getIt = GetIt.instance;
Future<void> initDependencies(Box blogsBox) async {
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonKey);

  getIt.registerLazySingleton(() => supabase.client);
  getIt.registerFactory(() => InternetConnection());
  getIt.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(internetConnection: getIt()));

  getIt.registerLazySingleton<Box>(() => blogsBox);
  // getIt.registerLazySingleton<Box>(() => casesBox);

  initAuth();
  initBlogs(blogsBox);
}

void initAuth() {
  getIt.registerFactory<ProfileLocalDatasource>(() => ProfileLocalDatasource());
  getIt.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: getIt()));
  getIt.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
      authRemoteDataSource: getIt(), connectionChecker: getIt(), profileLocalDatasource: getIt()));
  getIt.registerFactory<SignUpUseCase>(
      () => SignUpUseCase(authRepository: getIt()));

  getIt.registerFactory<SignInUseCase>(
      () => SignInUseCase(authRepository: getIt()));
  getIt.registerFactory<LogOutUsecase>(
      () => LogOutUsecase(authRepository: getIt()));

  getIt.registerFactory<UserStateUseCase>(
      () => UserStateUseCase(authRepository: getIt()));

  getIt.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(
      logOutUsecase: getIt(),
      signUpUseCase: getIt(),
      signInUseCase: getIt(),
      userStateUseCase: getIt(),
      appUserCubit: getIt()));
}

initBlogs(Box blogsBox) {
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
    ..registerFactory<FavBlogUseCase>(()=> FavBlogUseCase(blogRepository: getIt()))
    ..registerLazySingleton<BlogBloc>(
        () => BlogBloc(fetchBlogsUseCase: getIt(), uploadBlogUseCase: getIt(), favBlogUseCase: getIt()));
}
