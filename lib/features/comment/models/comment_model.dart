// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  final String commentId;
  final String blogId;
  final String userId;
  final String? parentId;
  final String content;
  final DateTime createdAt;
  final String authorName; 
  final String authorImg;
  final String commentsUserId;
  Comment({
    required this.commentsUserId,
    required this.commentId,
    required this.blogId,
    required this.userId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.authorName,
    required this.authorImg,
  });
  

  Comment copyWith({
    String? commentsUserId,
    String? commentId,
    String? blogId,
    String? userId,
    String? parentId,
    String? content,
    DateTime? createdAt,
    String? authorName,
    String? authorImg,
  }) {
    return Comment(
      commentsUserId: commentsUserId ?? this.commentsUserId,
      commentId: commentId ?? this.commentId,
      blogId: blogId ?? this.blogId,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      authorImg: authorImg ?? this.authorImg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'blogId': blogId,
      'userId': userId,
      'parentId': parentId,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'authorName': authorName,
      'authorImg': authorImg,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['id'] as String,
      blogId: map['blog_id'] as String ,
      userId: map['user_id'] as String,
      parentId: map['parent_id'] != null ? map['parent_id'] as String : null,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      authorName: map['profiles']['name'] as String,
      authorImg: map['profiles']['img_url'] as String,
      commentsUserId: map['profiles']['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(commentId: $commentId, blogId: $blogId, userId: $userId, parentId: $parentId, content: $content, createdAt: $createdAt, authorName: $authorName, authorImg: $authorImg, commentsUserId: $commentsUserId)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;
  
    return 
      other.commentId == commentId &&
      other.blogId == blogId &&
      other.userId == userId &&
      other.parentId == parentId &&
      other.content == content &&
      other.createdAt == createdAt &&
      other.authorName == authorName &&
      other.authorImg == authorImg;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
      blogId.hashCode ^
      userId.hashCode ^
      parentId.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      authorName.hashCode ^
      authorImg.hashCode;
  }
}
