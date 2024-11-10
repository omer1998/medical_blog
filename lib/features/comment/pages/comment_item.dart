import 'package:flutter/material.dart';
import 'package:medical_blog_app/features/comment/models/comment_model.dart';

class CommentItem extends StatelessWidget {
   final Comment comment;
  
  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.authorImg),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(comment.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(comment.timestamp.toString(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          subtitle: Text(comment.content),
        ),
      ),
    );
  }
}
