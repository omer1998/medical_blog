// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/calculate_reading_time.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blog;
  final Color backGroundColor;
  const BlogCard({
    Key? key,
    required this.backGroundColor,
    required this.blog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Document document; 
    // if (blog.content.startsWith('[{"insert":')){
    // document = Document.fromJson(jsonDecode(blog.content));

    // }else{
    //   document= Document();
    // }
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            BlogViewerPage.route(blog: blog),
          ),
          child: Container(
              height: 200,
              decoration: BoxDecoration(
                  color: backGroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                          child: Row(
                            children: blog.topics
                                .map(
                                  (e) => Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Chip(
                                        side: BorderSide.none,
                                        clipBehavior: Clip.antiAlias,
                                        label: Text(e)),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          blog.title.capitalize(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text("By ${blog.authorName}",
                        style: TextStyle(color: AppPallete.backgroundColor, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    
                  ],
                ),
              )),
        ));

    // topics
    //     .map((topic) => Container(
    //           child: Padding(
    //             padding: const EdgeInsets.all(7.0),
    //             child: Text(
    //               topic,
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(7),
    //             color: AppPallete.backgroundColor,
    //           ),
    //         ))
    //     .toList(),
  }
}
