// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/calculate_reading_time.dart';
import 'package:medical_blog_app/core/utils/capitalize_first_letter.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';

import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';

class BlogViewerPage extends StatefulWidget {
  static route({required BlogEntity blog}) =>
      MaterialPageRoute(builder: (_) => BlogViewerPage(blog: blog));
  final BlogEntity blog;
  const BlogViewerPage({
    Key? key,
    required this.blog,
  }) : super(key: key);

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  @override
  Widget build(BuildContext context) {
    // print("Author name inside blog viewer page");
    // print(blog.authorName);
     QuillController _qController;
    if (widget.blog.content.startsWith('[{"insert":')){
   _qController = QuillController(readOnly: true, document: Document.fromJson(jsonDecode(widget.blog.content)), selection: TextSelection.collapsed(offset: 0));

    }else {
       _qController = QuillController.basic();
    }


    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon:Icon(Icons.more_vert, color: AppPallete.gradient1,),
            onPressed: () {},
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.blog.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "By ${capitalizeFirstLetter(widget.blog.authorName ?? "Unkown author")}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${DateFormat("d MMM y").format(widget.blog.publishedDate)}  ${calculateReadingTime(widget.blog.content)} min.",
                  style: TextStyle(fontSize: 15, color: AppPallete.greyColor),
                ),
                SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: CachedNetworkImage(
                //     height: 300,
                //     fit: BoxFit.cover,
                //     imageUrl: blog.imageUrl,
                //     progressIndicatorBuilder:
                //         (context, url, downloadProgress) => Center(
                //       child: CircularProgressIndicator(
                //           value: downloadProgress.progress),
                //     ),
                //     errorWidget: (context, url, error) {
                //       return Icon(Icons.error);
                //     },
                //   ),
                // ),

                // Center(
                //   child: FutureBuilder(
                //       future: isConnected(),
                //       builder: (context, snapshot) {
                //         if (snapshot.data != null && snapshot.data == true) {
                //           return CachedNetworkImage(
                //             height: 300,
                //             fit: BoxFit.cover,
                //             imageUrl: blog.imageUrl,
                //             placeholder: (context, url) => Center(
                //                 child: const CircularProgressIndicator()),
                //           );
                //         } else if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return Container(
                //             height: 300,
                //           );
                //         } else {
                //           return Container(
                //             height: 300,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Icons.error,
                //                   size: 30,
                //                 ),
                //                 SizedBox(
                //                   height: 10,
                //                 ),
                //                 Text(
                //                   "No Internet Connection",
                //                   style: TextStyle(fontSize: 20),
                //                 )
                //               ],
                //             ),
                //           );
                //         }
                //       }),
                // ),

                // Center(
                //     child: CachedNetworkImage(
                //   key: UniqueKey(),
                //   height: 300,
                //   fit: BoxFit.cover,
                //   imageUrl: blog.imageUrl,
                //   placeholder: (context, url) =>
                //       Center(child: const CircularProgressIndicator()),
                //   errorWidget: (context, url, error) {
                //     return Text(error.toString());
                //   },
                // )),
                Center(
                  child: FastCachedImage(
                    height: 300,
                    fit: BoxFit.cover,
                    url: widget.blog.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "No Internet Connection",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (p0, p1) {
                      return SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()));
                    },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                widget.blog.content.startsWith('[{"insert":') ? QuillEditor(configurations: QuillEditorConfigurations(enableInteractiveSelection: false, controller: _qController), focusNode: FocusNode(), scrollController: ScrollController(),) :
                Text(
                  widget.blog.content,
                  style: TextStyle(fontSize: 16, height: 1.5),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
