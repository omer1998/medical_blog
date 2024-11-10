import 'package:flutter/material.dart';
import 'package:medical_blog_app/features/comment/models/comment_model.dart';

class CommentItem extends StatelessWidget {
   final Comment comment;
  
  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(comment.authorImg),
      ),
      title: Text(comment.authorName, style: TextStyle(fontSize: 12),),
      
      subtitle: Text(comment.content, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  }
