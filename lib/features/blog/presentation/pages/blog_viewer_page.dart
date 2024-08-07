// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/calculate_reading_time.dart';
import 'package:medical_blog_app/core/utils/capitalize_first_letter.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';
import 'package:medical_blog_app/core/utils/favorite_blog_service.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/blog/controllers/blog_controllers.dart';
import 'package:medical_blog_app/features/blog/data/repositories/riv_blog_repository.dart';

import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';

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
    BlocProvider.of<BlogBloc>(context, listen: false);
    QuillController _qController;
    if (widget.blog.content.startsWith('[{"insert":')) {
      _qController = QuillController(
          readOnly: true,
          document: Document.fromJson(jsonDecode(widget.blog.content)),
          selection: TextSelection.collapsed(offset: 0));
    } else {
      _qController = QuillController.basic();
    }

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppPallete.gradient1,
          ),
          onPressed: () {},
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.blog.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 24),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.message)),
                        Consumer(builder:(context, ref, child) {
                          // final isFav=   ;
                           print("isFav");
                          //  print(isFav.hasValue);
                          final params = BlogParams({"userId" : userId, "blogId": widget.blog.id});
                             return ref.watch(isFavoriteProvider.call(params)).when(
                              data: (data){
                                print("Data");
                                print(data);
                               return IconButton(
                                 onPressed: () {
                                   if (data) {
                                     ref.read(blogControllerProvider).removeFavBlog(context, userId, widget.blog.id);
                                   } else {
                                     ref.read(blogControllerProvider).addFavBlog(context,userId, widget.blog.id);
                                   }
                                 },
                                 icon: Icon(
                                   data ? Icons.favorite : Icons.favorite_border,
                                   color: data ? Colors.red : Colors.grey,
                                 ),
                               );
                             }, 
                             loading: (){
                               return const Loader();
                             
                           }, error:(error, stackTrace) {
                               showSnackBar(context, error.toString());
                                return Container();
                           },);
                          }),
                      ],
                    )
                    
                  ],
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
                widget.blog.content.startsWith('[{"insert":')
                    ? QuillEditor(
                        configurations: QuillEditorConfigurations(
                            enableInteractiveSelection: false,
                            controller: _qController),
                        focusNode: FocusNode(),
                        scrollController: ScrollController(),
                      )
                    : Text(
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

class BlogParams extends Equatable{
  final Map<String, dynamic> params;
  BlogParams(this.params);

  @override
  // TODO: implement props
  List<Object?> get props => params.keys.toList();
  
}