import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/add_new_blog_page.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          ("Blog"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
              icon: Icon(CupertinoIcons.add_circled))
        ],
      ),
    );
  }
}
