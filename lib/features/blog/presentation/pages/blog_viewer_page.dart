// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/calculate_reading_time.dart';
import 'package:medical_blog_app/core/utils/capitalize_first_letter.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/core/utils/favorite_blog_service.dart';
import 'package:medical_blog_app/core/utils/follow_user.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/blog/controllers/blog_controllers.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:medical_blog_app/features/blog/data/repositories/riv_blog_repository.dart';

import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_image_embed_builder.dart';
import 'package:medical_blog_app/features/comment/pages/comment_section.dart';
import 'package:medical_blog_app/features/comment/pages/comment_section_tile.dart';
import 'package:medical_blog_app/features/comment/repository/comment_repository.dart';
import 'package:medical_blog_app/features/profile/controller/profile_controller.dart';
import 'package:medical_blog_app/features/profile/page/profile_page_viewer_only.dart';

class BlogViewerPage extends StatefulWidget {
  static route({required BlogEntity blog, required UserEntity user}) =>
      MaterialPageRoute(
          builder: (_) => BlogViewerPage(
                blog: blog,
                user: user,
              ));
  final BlogEntity blog;
  final UserEntity user;
  const BlogViewerPage({
    Key? key,
    required this.blog,
    required this.user,
  }) : super(key: key);

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final userId =
    //     (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
    //         .user
    //         .id;
    // BlocProvider.of<BlogBloc>(context, listen: false)
    //     .add(GetFavBlogsEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    // print("Author name inside blog viewer page");
    // print(blog.authorName);.
    
    final userId =
        (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
            .user
            .id;
    print("user id is : $userId");
    final sampleContent=jsonEncode([{"insert":"this is a new blog post from custom omer\n"},{"insert":{"image":"https://unhkwlvbdldgqnxmfpaw.supabase.co/storage/v1/object/public/avatars/omer%20faris11734324133967"}},{"insert":"\n"}]); 
    
    BlocProvider.of<BlogBloc>(context, listen: false);
    QuillController _qController;
    if (widget.blog.content.startsWith('[{"insert":')) {
      _qController = QuillController(
          readOnly: true,
          document: Document.fromJson(jsonDecode(widget.blog.content)),
          // document:  Document.fromJson(jsonDecode(sampleContent)),
          selection: TextSelection.collapsed(offset: 0));
    } else {
      _qController = QuillController.basic();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(actions: [
        // IconButton(
        //   icon: Icon(
        //     Icons.more_vert,
        //     color: AppPallete.gradient1,
        //   ),
        //   onPressed: () {
            
        //   },
        // ),
        userId == widget.blog.authorId
            ? MenuAnchor(
              style: MenuStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.focused)) {
          return Theme.of(context).colorScheme.primary.withOpacity(0.5);
        }
        return null; // Use the component's default.
      },
    ),
    shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
      (Set<WidgetState> states) {
        return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          );
      },
    ),
    maximumSize: WidgetStateProperty.resolveWith<Size>(
      (Set<WidgetState> states) {
        return Size(200, 200);
      },
    )
  ),
              builder: (context, controller, dismiss) => IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: Icon(Icons.more_vert, color: AppPallete.gradient1),
              ),
                // child: Icon(Icons.more_vert, color: AppPallete.gradient1),
              menuChildren: [
              MenuItemButton(child: Text("Edit",),
                onPressed: () {
                showSnackBar(context, "To Be Implemented Later");
              }),
              MenuItemButton(child: Text("Delete"),
                onPressed: () {
                showSnackBar(context, "To Be Implemented Later");
              
              })
            ]): Container(),
        
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.blog.title.capitalize(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 24),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Consumer(
                                      builder: (_, WidgetRef ref, __) {
                                        return IconButton(
                                            onPressed: () async {
                                              final userId = (BlocProvider
                                                              .of<AppUserCubit>(
                                                                  context)
                                                          .state
                                                      as UserLoggedInState)
                                                  .user
                                                  .id;
                                              // await ref.read(commentRepositoryProvider).getComments(widget.blog.id);
                                              showModalBottomSheet(
                                                showDragHandle: true,
                                                // barrierLabel: ,
                                                // enableDrag: false,
                                                useSafeArea: true,
                                                barrierColor: Colors.grey,
                                                context: context,
                                                builder: (context) {
                                                  return CommentsSection(
                                                    blogId: widget.blog.id,
                                                    userId: userId,
                                                    mainUserImgUrl:
                                                        widget.user.img_url!,
                                                  );
                                                },
                                                isScrollControlled: true,
                                              );
                                            },
                                            icon: Icon(Icons.message));
                                      },
                                    ),
                                    Consumer(builder: (context, ref, child) {
                                      // final isFav=   ;
                                      print("isFav");
                                      //  print(isFav.hasValue);
                                      final params = BlogParams({
                                        "userId": userId,
                                        "blogId": widget.blog.id
                                      });
                                      return ref
                                          .watch(
                                              isFavoriteProvider.call(params))
                                          .when(
                                        data: (data) {
                                          print("Data");
                                          print(data);
                                          return IconButton(
                                            onPressed: () {
                                              if (data) {
                                                ref
                                                    .read(
                                                        blogControllerProvider.notifier)
                                                    .removeFavBlog(context,
                                                        userId, widget.blog.id);
                                              } else {
                                                ref
                                                    .read(
                                                        blogControllerProvider.notifier)
                                                    .addFavBlog(context, userId,
                                                        widget.blog.id);
                                              }
                                            },
                                            icon: Icon(
                                              data
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: data
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          );
                                        },
                                        loading: () {
                                          return const Loader();
                                        },
                                        error: (error, stackTrace) {
                                          // showSnackBar(context, error.toString());

                                          return Icon(Icons.error);
                                        },
                                      );
                                    }),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                        width: double.infinity,
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return ref
                                                .watch(
                                                    getUserProfileInfoProvider
                                                        .call(widget
                                                            .blog.authorId))
                                                .when(
                                              data: (data) {
                                                return SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      // Image.asset("./assets/images/profile_images/doctor_logo_3.jpg"),
                                                      data.img_url != null &&
                                                              data.img_url!
                                                                  .isNotEmpty
                                                          ? CircleAvatar(
                                                              radius: 50,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .img_url!),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 50,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                "./assets/images/profile_images/doctor_logo_3.jpg",
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            data.name
                                                                .capitalize(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          // IconButton.outlined(onPressed: (){

                                                          // }, icon: Icon(Icons.tab))
                                                          // widget.user.id ==
                                                          //         widget.blog
                                                          //             .authorId
                                                          //     ? Container()
                                                          //     : Consumer(
                                                          //         builder: (_,
                                                          //             WidgetRef
                                                          //                 ref,
                                                          //             __) {
                                                          //           return FutureBuilder<
                                                          //                   bool>(
                                                          //               future: ref.read(followUtilityProvider).isFollowed(
                                                          //                   widget
                                                          //                       .user.id,
                                                          //                   widget
                                                          //                       .blog.authorId),
                                                          //               builder:
                                                          //                   (context,
                                                          //                       snapshot) {
                                                          //                 print(
                                                          //                     "snapshot data");
                                                          //                 print(
                                                          //                     snapshot.data);
                                                          //                 if (snapshot.connectionState ==
                                                          //                     ConnectionState
                                                          //                         .waiting) {
                                                          //                   return Loader();
                                                          //                 } else if (snapshot.connectionState == ConnectionState.done &&
                                                          //                     snapshot.hasData) {
                                                          //                   return IconButton.outlined(
                                                          //                       onPressed: () async {
                                                          //                         if (snapshot.data == true) {
                                                          //                           // mean the user is following this writer
                                                          //                           // on press here again it will unfollow
                                                          //                           print(" this user if following the other user" );
                                                          //                             await ref.read(followUtilityProvider).removeFollow(widget.user.id, widget.blog.authorId);

                                                          //                           setState(() {
                                                          //                           });
                                                          //                         }
                                                          //                         await ref.read(followUtilityProvider).addFollow(widget.user.id, widget.blog.authorId);

                                                          //                         setState(()  {});
                                                          //                       },
                                                          //                       icon: Padding(
                                                          //                         padding: const EdgeInsets.all(1.0),
                                                          //                         child: Icon(
                                                          //                           snapshot.data == true ? FontAwesome.circle_check_solid : FontAwesome.user_plus_solid,
                                                          //                           size: 18,
                                                          //                           color: Colors.green,
                                                          //                         ),
                                                          //                       ));
                                                          //                 } else {
                                                          //                   print(snapshot.error.toString());
                                                          //                   return Icon(Icons.error);
                                                          //                 }
                                                          //               });
                                                          //         },
                                                          //       ),
                                                          // widget.user.id ==
                                                          //         widget.blog
                                                          //             .authorId
                                                          //     ? Container()
                                                          //     : IconButton
                                                          //         .outlined(
                                                          //             onPressed:
                                                          //                 () {},
                                                          //             icon:
                                                          //                 Padding(
                                                          //               padding: const EdgeInsets
                                                          //                   .all(
                                                          //                   1.0),
                                                          //               child:
                                                          //                   Icon(
                                                          //                 FontAwesome
                                                          //                     .message,
                                                          //                 color:
                                                          //                     Colors.yellow,
                                                          //                 size:
                                                          //                     18,
                                                          //               ),
                                                          //             ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          data.about ?? "",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      IconButton.outlined(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProfilePageViewer(
                                                                        mainUserId: widget.user.id,
                                                                        blog: widget.blog as BlogModel,
                                                                          user: data
                                                                              as UserModel)));
                                                        },
                                                        icon: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.info,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text("More")
                                                          ],
                                                        ),
                                                      )
                                                    ]),
                                                  ),
                                                );
                                              },
                                              error: (error, stackTrace) {
                                                return Center(
                                                    child:
                                                        Text(error.toString()));
                                              },
                                              loading: () {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                            );
                                          },
                                        ));
                                  },
                                );
                              },
                              child: Text(
                                "By ${capitalizeFirstLetter(widget.blog.authorName ?? "Unkown author")}",
                                style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500,
                                  //  decoration: TextDecoration.underline
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${DateFormat("d MMM y").format(widget.blog.publishedDate)}  ${calculateReadingTime(widget.blog.content)} min.",
                              style: TextStyle(
                                  fontSize: 15, color: AppPallete.greyColor),
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
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FastCachedImage(
                                  height: 300,
                                  fit: BoxFit.cover,
                                  url: widget.blog.imageUrl,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "No Internet Connection : ${error.toString()}",
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  loadingBuilder: (p0, p1) {
                                    return SizedBox(
                                        height: 300,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  },
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            widget.blog.content.startsWith('[{"insert":')
                                ? QuillEditor(
                                    configurations: QuillEditorConfigurations(
                                        enableInteractiveSelection: false,
                                        embedBuilders: [
                                          BlogImageEmbedBuilder()
                                        ],
                                        controller: _qController),
                                    focusNode: FocusNode(),
                                    scrollController: ScrollController(),
                                  )
                                : widget.blog.contentJson != null &&
                                        widget.blog.contentJson!.isNotEmpty
                                    ? Column(
                                        children: (jsonDecode(
                                                    widget.blog.contentJson!)
                                                as List)
                                            .map((content) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              capitalizeFirstLetter(
                                                  content["title"]),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              content["content"],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            (content['images'] as List)
                                                    .isNotEmpty
                                                ? Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Image.network(
                                                        width: 400,
                                                        fit: BoxFit.cover,
                                                        frameBuilder: (context,
                                                            child,
                                                            frame,
                                                            wasSynchronouslyLoaded) {
                                                      return child;
                                                    }, loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                              child: CircularProgressIndicator(
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                      : null)),
                                                        );
                                                      }
                                                    }, errorBuilder: (context,
                                                            error, stackTrace) {
                                                      return Icon(Icons.error);
                                                    }, content['images'][0]),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      }).toList())
                                    // ListView.builder(
                                    //   shrinkWrap: true,
                                    //   itemCount: (jsonDecode(widget.blog.contentJson!)).length,
                                    //   itemBuilder: (context, indext ){
                                    //     final content = jsonDecode(widget.blog.contentJson!)[indext];
                                    //     print("content");
                                    //     print(content);
                                    //     return Column(
                                    //       crossAxisAlignment: CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text( capitalizeFirstLetter(content["title"]), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),

                                    //         Text( content["content"], style: TextStyle(fontSize: 16),),
                                    //         SizedBox( height: 10,),
                                    //         (content['images'] as List).isNotEmpty? Container(
                                    //           clipBehavior: Clip.hardEdge,
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(10),

                                    //           ),
                                    //           child: Image.network(
                                    //             width: 400,
                                    //             fit: BoxFit.cover,
                                    //             frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                    //               return child;
                                    //             },
                                    //             errorBuilder: (context, error, stackTrace){
                                    //               return Icon(Icons.error);
                                    //             },
                                    //             content['images'][0]),
                                    //         ) : Container(),
                                    //           SizedBox( height: 20,),

                                    //       ],
                                    //     ) ;
                                    //   } )
                                    : Text(
                                        widget.blog.content,
                                        style: TextStyle(
                                            fontSize: 16, height: 1.5),
                                      ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        CommentSectionTile(
                          userId: userId,
                          blogId: widget.blog.id,
                          userImgUrl: widget.user.img_url!,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogParams extends Equatable {
  final Map<String, dynamic> params;
  BlogParams(this.params);

  @override
  // TODO: implement props
  List<Object?> get props => params.keys.toList();
}
