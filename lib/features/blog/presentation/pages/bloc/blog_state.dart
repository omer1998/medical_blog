part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogsSuccessState extends BlogState {
  final List<BlogEntity> blogs;
  final String? selectedTopic;
  final List<String> availableTopics;


  BlogsSuccessState({required this.blogs, this.selectedTopic, required this.availableTopics});
}

final class BlogSuccessState extends BlogState {}

final class BlogLoadingState extends BlogState {}

final class BlogFailureState extends BlogState {
  final String message;

  BlogFailureState({required this.message});
}

final class FavBlogSuccessState extends BlogState {}
final class FavBlogFailureState extends BlogState {
  final String message;

  FavBlogFailureState({required this.message});
}
final class FavBlogLoadingState extends BlogState {}
final class AllBlogFavSuccessState extends BlogState {
  final List<BlogEntity> blogs;

  AllBlogFavSuccessState({required this.blogs});
}
