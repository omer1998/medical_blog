// ignore_for_file: public_member_api_docs, sort_constructors_first

class BlogEntity {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final DateTime publishedDate;
  final List<String> topics;
  final String imageUrl;
  final String? authorName;

  BlogEntity(
      {required this.id,
      required this.title,
      required this.content,
      required this.authorId,
      required this.publishedDate,
      required this.topics,
      required this.imageUrl,
      this.authorName});
}
