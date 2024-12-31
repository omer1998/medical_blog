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
      required this.topics, 
      });
}


final class BlogFetchBlogsEvent extends BlogEvent {}

final class BlogFilterByTopicEvent extends BlogEvent {
  final String? selectedTopic;

  BlogFilterByTopicEvent(this.selectedTopic);
}

final class FavBlogEvent extends BlogEvent{
  final String blogId;
  final String userId;
  FavBlogEvent({required this.blogId, required this.userId});
}

final class GetFavBlogsEvent extends BlogEvent{
  final String userId;
  GetFavBlogsEvent({required this.userId});
}

final class RemoveFavBlogEvent extends BlogEvent{
  final String blogId;
  final String userId;
  RemoveFavBlogEvent({required this.blogId, required this.userId});
}
