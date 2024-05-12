part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadBlogEvent extends BlogEvent {
  final String title;
  final String content;
  final List<String> topics;
  final File image;
  final String authorId;

  BlogUploadBlogEvent(
      {required this.authorId,
      required this.image,
      required this.title,
      required this.content,
      required this.topics});
}

final class BlogFetchBlogsEvent extends BlogEvent {}
