import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_seg_title.dart';

final selectedTagsProvider = StateProvider<List<String>>((ref) {
  return [] ;
});

class TopicTags extends ConsumerStatefulWidget {
  final List<String> tags;
  const TopicTags({super.key, required this.tags});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopicTagsState();
}
class _TopicTagsState extends ConsumerState<TopicTags> {

    final TextEditingController tagController = TextEditingController();
  List<String> selectedTopics = [];
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Wrap(
            spacing: 10,
            children: widget.tags
                .map((e) => FilterChip(
                    /* side: selectedTopics.contains(e)
                        ? BorderSide.none
                        : BorderSide(color: AppPallete.borderColor),
                    backgroundColor: selectedTopics.contains(e)
                        ? AppPallete.gradient1
                        : null, */
                        selected: selectedTopics.contains(e),
                    selectedColor: AppPallete.gradient1.withOpacity(0.2),
                    label: Text(e),
                    labelStyle: TextStyle(
                      color: selectedTopics.contains(e)
                          ? AppPallete.gradient1
                          : AppPallete.whiteColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: selectedTopics.contains(e)
                            ? AppPallete.gradient1
                            : AppPallete.borderColor,
                      ),
                     
                    ),
                    onSelected: (bool value) { 
                      if (!selectedTopics.contains(e))
                        {
                          selectedTopics.add(e);
                          
                        }
                      else
                        {
                          selectedTopics.remove(e);
                               
                        }
                              return setState(() {
                    ref.read(selectedTagsProvider.notifier).state= selectedTopics;
                      
                    });
                     },))
                .toList()),
      SizedBox(height: 10,),
      ActionChip(label: Text("Add Tag"), onPressed:() async {
        await showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          
          
           builder: (context) {
          return Container(
            
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              // color: AppPallete.whiteColor,
              
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              
            ),
            child: Column(
              children: [
                SizedBox(height: 10,),
                SizedBox(width: 40, child: Divider(thickness: 3, color: Colors.white,),),
                
                
                Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CaseSegmentTitle(title: "Add Tag"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: "Enter Tag",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text("Add"),
                      onPressed: () {
                     setState(() {
                        widget.tags.insert(0, tagController.text.trim());
                        selectedTopics.add(tagController.text.trim());
                     });
                      tagController.clear();
                      Navigator.pop(context); }),
                  )],
              ),]
            ),
          );
        }, context: context);
      },)
            ],
          );
  }
}
// class TopicTags extends StatefulWidget {
//   final List<String> tags;
//   const TopicTags({super.key, required this.tags});

//   @override
//   State<TopicTags> createState() => _TopicTagsState();
// }

// class _TopicTagsState extends State<TopicTags> {
//   final TextEditingController tagController = TextEditingController();
//   List<String> selectedTopics = [];
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
