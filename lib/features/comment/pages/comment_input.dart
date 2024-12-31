import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/features/comment/controllers/comment_controller.dart';

class CommentInput extends ConsumerStatefulWidget {
  final String blogId;
  final String userId;
  final ScrollController? scroll;
  final String mainUserImgUrl;
  const CommentInput({ this.scroll, super.key,required this.mainUserImgUrl, required this.blogId, required this.userId});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  final formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.mainUserImgUrl),
          ),
          title: TextFormField(
            
            onChanged: (value) {
              setState(() {
                
              });
            },
            controller: contentController,
            
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Add Comment",
           
              
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: contentController.text.isEmpty? null : () async {
                    if (formKey.currentState!.validate()) {
                      print("blogId ${widget.blogId}");
                      print("userId ${widget.userId}");
                      print("content ${contentController.text}");

                      await ref.read(commentControllerProvider).addCommment(
                          context: context,
                          content: contentController.text.trim(),
                          userId: widget.userId,
                          blogId: widget.blogId,
                          parentId: null); //TODO: add user id
                      contentController.clear();
          ref.refresh(getCommentsProvider.call(widget.blogId));
                     widget.scroll?.animateTo(widget.scroll!.position.maxScrollExtent, duration: Duration(milliseconds: 150), curve: Curves.easeIn);

          


                    }
                  }),
            ),
          ),
        ));
  }
}
