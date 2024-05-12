part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogsSuccessState extends BlogState {
  final List<BlogEntity> blogs;

  BlogsSuccessState({required this.blogs});
}

final class BlogSuccessState extends BlogState {}

final class BlogLoadingState extends BlogState {}

final class BlogFailureState extends BlogState {
  final String message;

  BlogFailureState({required this.message});
}
