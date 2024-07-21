import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';

class BlogModel extends BlogEntity {
  BlogModel(
      {required super.id,
      required super.title,
      required super.content,
      required super.authorId,
      required super.publishedDate,
      required super.topics,
      required super.imageUrl,
      super.authorName});

  @override
  String toString() {
    return "$authorId , $title, $content, $authorId, $publishedDate, $topics, $imageUrl";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorId,
      'published_date': publishedDate.toIso8601String(),
      'topics': topics,
      'image_url': imageUrl,
      "author_name": authorName
    };
  }
  Map<String, dynamic> toMapInsert(){
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorId,
      'published_date': publishedDate.toIso8601String(),
      'topics': topics,
      'image_url': imageUrl,
    };
  }
  factory BlogModel.fromMap(Map<dynamic, dynamic> map) {
    return BlogModel(
        id: map['id'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
        authorId: map['author_id'] as String,
        publishedDate: DateTime.parse(map['published_date']),
        topics: List.from(map['topics']).cast<String>(),
        imageUrl: map["image_url"],
        authorName: map['profiles']['name'] ?? "");
  }
  factory BlogModel.fromJson(Map<dynamic, dynamic> map) {
    return BlogModel(
        id: map['id'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
        authorId: map['author_id'] as String,
        publishedDate: DateTime.parse(map['published_date']),
        topics: List.from(map['topics']).cast<String>(),
        imageUrl: map["image_url"],
        authorName: map['author_name']);
  }

  BlogModel copyWith({
    String? id,
    String? title,
    String? content,
    String? authorId,
    DateTime? publishedDate,
    List<String>? topics,
    String? imageUrl,
    String? authorName,
  }) {
    return BlogModel(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        authorId: authorId ?? this.authorId,
        publishedDate: publishedDate ?? this.publishedDate,
        topics: topics ?? this.topics,
        imageUrl: imageUrl ?? this.imageUrl,
        authorName: authorName ?? this.authorName);
  }
}
