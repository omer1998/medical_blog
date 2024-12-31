import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/features/comment/controllers/comment_controller.dart';
import 'package:medical_blog_app/features/comment/pages/comment_input.dart';
import 'package:medical_blog_app/features/comment/pages/comment_item.dart';

class CommentsSection extends ConsumerStatefulWidget {
    final String blogId;
  final String userId;
  final String mainUserImgUrl;
  const CommentsSection({required this.mainUserImgUrl, required this.blogId, required this.userId, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsSectionState();
}
class _CommentsSectionState extends ConsumerState<CommentsSection> {
  final scrollController = ScrollController();

@override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return 
    Scrollbar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // SizedBox(height: 10,),
            // SizedBox(
            //   width: 50,
            //   child: Divider(thickness: 4)),
            Text("Comments", style: TextStyle(
              fontSize: 20
            ),),SizedBox(height: 20,),
            ref.watch(getCommentsProvider.call(widget.blogId)).when(data: (data){
                                  if (data.isEmpty) {
                                    return const Center(child: Text("No comments yet"));
                                  }
                                  return Expanded(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return CommentItem(comment: data[index]);
                                      },
                                    ),
                                  );
                                
                                }, error:(error, stackTrace) {
                      
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, size: 40,),
                                      SizedBox(height: 10,),
                                      Text(error.toString())
                                    ],
                                  );
                                
                                }, loading: ()=> Loader()),
                                SizedBox(height: 10,),
                                CommentInput(blogId: widget.blogId, userId: widget.userId,scroll: scrollController, mainUserImgUrl: widget.mainUserImgUrl,),],
        ),
      ),
    );
    // return ExpansionTile(
    //   shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(10),
    //                           side:  BorderSide.none),
    //                       collapsedShape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(10),
    //                           side:  BorderSide.none),
    //                       collapsedBackgroundColor: const Color.fromARGB(255, 0, 51, 45),
    //                       backgroundColor: const Color.fromARGB(255, 0, 51, 45),
    //                       title: Text("Comments"),
    //                       children: [
    //                         ref.watch(getCommentsProvider.call(blogId)).when(data: (data){
    //                           if (data.isEmpty) {
    //                             return const Center(child: Text("No comments yet"));
    //                           }
    //                           return ListView.builder(
    //                             shrinkWrap: true,
    //                             // physics: const NeverScrollableScrollPhysics(),
    //                             itemCount: data.length,
    //                             itemBuilder: (context, index) {
    //                               return CommentItem(comment: data[index]);
    //                             },
    //                           );
                            
    //                         }, error:(error, stackTrace) {

    //                           return Center(child: Text(error.toString()));
                            
    //                         }, loading: ()=> Loader()),
    //                         CommentInput(blogId: blogId, userId: userId,),
    //                       ]
    //                     );
  }
}
