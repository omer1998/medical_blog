import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';

class TagsChips extends ConsumerStatefulWidget {
  final List<String> tags;
  const TagsChips({required this.tags, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TagsChipsState();
}

class TagsChipsState extends ConsumerState<TagsChips> {
  List<String> selectedTags = [];
  
  @override
  Widget build(BuildContext context) {
    if (ref.read(selectedTagsProvider).isNotEmpty){
      selectedTags = ref.read(selectedTagsProvider);
    }
    return Wrap(
      spacing: 5.0,
      children: widget.tags.map((String tag) {
        return FilterChip(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          label: Text(tag),
          selected: selectedTags.contains(tag),
          onSelected: (selected) async {
            if (selected) {
              selectedTags.add(tag);
              ref.read(selectedTagsProvider.notifier).state = selectedTags;
              // final res = await ref
              //     .read(casesLocalDataSourceProvider)
              //     .retrieveCasesByTags(selectedTags);
              // res.fold((failure) {
              //   showSnackBar(
              //       context, failure.message);
              // }, (cases) {
              //   showSnackBar(
              //       context, cases.toString());
              // });
              setState(() {
                // ref.read(caseControllerProvider).retriveCasesByTags(context);
              });
            } else {
              setState(() {
                selectedTags.remove(tag);
                ref.read(selectedTagsProvider.notifier).state = selectedTags;
              });
            }
          },
          // selected: filters.contains(exercise),
          // onSelected: (bool selected) {
          //   setState(() {
          //     if (selected) {
          //       filters.add(exercise);
          //     } else {
          //       filters.remove(exercise);
          //     }
          //   });
          // },
        );
      }).toList(),
    );
  }
}
