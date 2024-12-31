import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/comment/controllers/comment_controller.dart';
import 'package:medical_blog_app/features/comment/models/comment_model.dart';
import 'package:medical_blog_app/features/comment/pages/comment_input.dart';
import 'package:medical_blog_app/features/comment/pages/comment_item.dart';

// class CommentSectionTile extends ConsumerWidget {
//   final String blogId;
//   final String userId;
//   final String userImgUrl;
//   const CommentSectionTile({required this.userImgUrl, required this.userId,  required this.blogId, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
    
//     return ExpansionTile(
//       initiallyExpanded: true,
//       shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               side:  BorderSide.none),
//                           collapsedShape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               side:  BorderSide.none),
//                           collapsedBackgroundColor: const Color.fromARGB(255, 0, 51, 45),
//                           backgroundColor: const Color.fromARGB(255, 0, 51, 45),
//                           title: Text("Comments"),
//                           children: [
//                             ref.watch(getCommentsProvider.call(blogId)).when(data: (data){
//                               if (data.isEmpty) {
//                                 return const Center(child: Text("No comments yet"));
//                               }
//                               return ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: data.length,
//                                 itemBuilder: (context, index) {
//                                   return CommentItem(comment: data[index]);
//                                 },
//                               );
                            
//                             }, error:(error, stackTrace) {

//                               return Center(child: Text(error.toString()));
                            
//                             }, loading: ()=> Loader()),
//                             CommentInput(blogId: blogId, userId: userId,mainUserImgUrl: userImgUrl,),
//                           ]
//                         );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class CommentSectionTile extends ConsumerWidget {
  final String blogId;
  final String userId;
  final String userImgUrl;

  const CommentSectionTile({
    required this.userImgUrl,
    required this.userId,
    required this.blogId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("blog id: $blogId");
    return ExpansionTile(
      initiallyExpanded: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      collapsedBackgroundColor: AppPallete.borderColor.withOpacity(0.8),
      backgroundColor: AppPallete.backgroundColor,
      title: Text(
        "Comments",
        style: TextStyle(
          color: AppPallete.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        ref.watch(getCommentsProvider.call(blogId)).when(
          data: (data) {
            print("comment data: $data");
            if (data.isEmpty) {
              
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    "No comments yet",
                    style: TextStyle(color: AppPallete.greyColor),
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return CommentItem(comment: data[index]);
              },
            );
          },
          error: (error, stackTrace) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "Error loading comments : $error",
                  style: TextStyle(color: AppPallete.errorColor),
                ),
              ),
            );
          },
          loading: () => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(child: CircularProgressIndicator(color: AppPallete.gradient1)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CommentInput(
            blogId: blogId,
            userId: userId,
            mainUserImgUrl: userImgUrl,
          ),
        ),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(comment.authorImg),
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppPallete.borderColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.authorName,
                    style: TextStyle(
                      color: AppPallete.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: TextStyle(
                      color: AppPallete.whiteColor.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat("dd MMM yyyy, hh:mm a").format(comment.createdAt),
                    style: TextStyle(
                      color: AppPallete.greyColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CommentInput extends ConsumerStatefulWidget {
  final String blogId;
  final String userId;
  final String mainUserImgUrl;
  const CommentInput({super.key, required this.blogId,
    required this.userId,
    required this.mainUserImgUrl,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(widget.mainUserImgUrl),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Form(
            child: TextFormField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: "Add a comment...",
                hintStyle: TextStyle(color: AppPallete.greyColor.withOpacity(0.7)),
                filled: true,
                fillColor: AppPallete.borderColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: AppPallete.whiteColor),
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.send, color: AppPallete.gradient1),
          onPressed: () async {
            // Implement comment submission logic here
            await ref.read(commentControllerProvider).addCommment(
                          context: context,
                          content: contentController.text.trim(),
                          userId: widget.userId,
                          blogId: widget.blogId,
                          parentId: null); 
          },
        ),
      ],
    );
  }
}
