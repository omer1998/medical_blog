import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:share_plus/share_plus.dart';

// class NewBlogCard extends StatelessWidget {
//   final BlogEntity blog;
//   final UserEntity mainAppUser;
//   const NewBlogCard({super.key, required this.blog, required this.mainAppUser});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: GestureDetector(
//         onTap: () => Navigator.of(context).push(
//           BlogViewerPage.route(blog: blog, user: mainAppUser),
//         ),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   // color:  Color.fromARGB(255, 76, 3, 96)
//                   ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Container(
//                   //     decoration: BoxDecoration(
//                   //       borderRadius: BorderRadius.circular(10),
//                   //     ),
//                   //     clipBehavior: Clip.hardEdge,
//                   //     child: CachedNetworkImage(
//                   //       imageUrl: blog.imageUrl,
//                   //       width: 150,
//                   //       height: 150,
//                   //       fit: BoxFit.cover,
//                   //       placeholder: (context, url) => Image.asset(
//                   //           "./assets/images/profile_images/doctor-image.jpg"),
//                   //       errorWidget: (context, url, error) => Icon(Icons.error),
//                   //     )
//                   //     // Image.network(
//                   //     //   width: 150,
//                   //     //   height: 150,
//                   //     //   blog.imageUrl,
//                   //     //   fit: BoxFit.cover,
//                   //     //   loadingBuilder: (context, child, loadingProgress) {
//                   //     //     if (loadingProgress == null) return child;
//                   //     //     return Padding(
//                   //     //       padding: const EdgeInsets.all(18.0),
//                   //     //       child: Center(
//                   //     //           child: CircularProgressIndicator(
//                   //     //         value: loadingProgress.expectedTotalBytes != null
//                   //     //             ? loadingProgress.cumulativeBytesLoaded /
//                   //     //                 loadingProgress.expectedTotalBytes!
//                   //     //             : null,
//                   //     //       )),
//                   //     //     );
//                   //     //   },
//                   //     // )
//                   //     ),
//                   // SizedBox(width: 10),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             blog.title.capitalize(),
//                             maxLines: 2,
//                             overflow: TextOverflow.fade,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                           SizedBox(height: 5),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: blog.topics
//                                   .map(
//                                     (e) => Container(
//                                       margin: EdgeInsets.only(right: 5),
//                                       child: Chip(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 76, 3, 96),
//                                           side: BorderSide.none,
//                                           clipBehavior: Clip.antiAlias,
//                                           label: Text(e)),
//                                     ),
//                                   )
//                                   .toList(),
//                             ),
//                           ),
//                           // blog.contentJson != null &&
//                           //         blog.contentJson!.isNotEmpty
//                           //     ? Text(
//                           //         maxLines: 2,
//                           //         "${(jsonDecode(blog.contentJson!)[0]["content"] as String).substring(0, (jsonDecode(blog.contentJson!)[0]["content"] as String).length - 5)} ...")
//                           //     : Text(
//                           //         maxLines: 2,
//                           //         "${blog.content.capitalize().substring(0, 4)} ...",
//                           //         overflow: TextOverflow.fade,
//                           //         style: TextStyle(
//                           //             fontWeight: FontWeight.bold,
//                           //             fontSize: 18),
//                           //       ),
                         
//                         ],
//                       ),
//                     ),
//                   ),
//                 blog.imageUrl.isNotEmpty ? Padding(
//                   padding: const EdgeInsets.only(top: 8.0, right: 8.0),
//                   child: CachedNetworkImage(imageUrl: blog.imageUrl, width: 100, height: 100, fit:   BoxFit.cover, progressIndicatorBuilder: (context, url, progress) {
//                     return Center(child: CircularProgressIndicator(value: progress.progress));
//                   },),
//                 ): Container(),
//                 ],
//               ),
//             ),
//              SizedBox(height: 5),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                             Text("By ${blog.authorName!.capitalize()} | ${DateFormat("dd MMM yyyy").format((blog.publishedDate))}"),
                                              
//                             IconButton(onPressed: (){
//                               Share.share('Check out this blog: ${blog.title}');
//                             }, icon: Icon(Icons.share, color:Color.fromARGB(255, 144, 192, 255),))
               
//                ],),
//              ),
//             Padding(
//               padding: const EdgeInsets.only( right: 8, left: 8),
//               child: Divider(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class NewBlogCard extends StatelessWidget {
  final BlogEntity blog;
  final UserEntity mainAppUser;

  const NewBlogCard({
    Key? key,
    required this.blog,
    required this.mainAppUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          BlogViewerPage.route(blog: blog, user: mainAppUser),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppPallete.backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with overlay for author name
              if (blog.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: blog.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppPallete.gradient1.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            blog.authorName!.capitalize(),
                            style: TextStyle(
                              color: AppPallete.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blog title
                    Text(
                      blog.title.capitalize(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Blog topics as styled chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: blog.topics.map((topic) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: Chip(
                              label: Text(
                                topic,
                                style: TextStyle(
                                  color: AppPallete.gradient1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: AppPallete.borderColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Blog preview text
                    Text(
                      blog.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppPallete.greyColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Footer with author, date, and share button
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Author and date
                    Text(
                      "By ${blog.authorName!.capitalize()} | ${DateFormat("dd MMM yyyy").format(blog.publishedDate)}",
                      style: TextStyle(
                        color: AppPallete.greyColor,
                        fontSize: 12,
                      ),
                    ),
                    // Share button
                    IconButton(
                      onPressed: () {
                        Share.share('Check out this blog: ${blog.title}');
                      },
                      icon: Icon(
                        Icons.share,
                        color: AppPallete.gradient2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}