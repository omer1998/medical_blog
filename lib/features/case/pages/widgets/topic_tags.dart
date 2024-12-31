import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';

class TopicTags extends ConsumerStatefulWidget {
  final List<String> tags;
  final Function(List<String>)? onSelected;

  const TopicTags({
    Key? key,
    required this.tags,
    this.onSelected,
  }) : super(key: key);

  @override
  ConsumerState<TopicTags> createState() => _TopicTagsState();
}

class _TopicTagsState extends ConsumerState<TopicTags> {
  final _tagController = TextEditingController();
  final _formTagKey = GlobalKey<FormState>();
  late List<String> _availableTags;

  @override
  void initState() {
    super.initState();
    _availableTags = List.from(widget.tags);
    // Initialize provider if it's empty
    /* final currentTags = ref.read(getCasesTagsProvider);
    if (currentTags.isEmpty) {
      ref.read(getCasesTagsProvider.notifier).state = _availableTags;
    } else {
      _availableTags = List.from(currentTags);
    } */
  }

  /* @override
  void didUpdateWidget(TopicTags oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tags != widget.tags) {
      _availableTags = List.from(widget.tags);
      ref.read(getCasesTagsProvider.notifier).state = _availableTags;
    }
  } */

  void _addNewTag(String newTag) {
    if (!_availableTags.contains(newTag)) {
      setState(() {
        _availableTags.add(newTag);
        // Update both providers
        
        final selectedTags = ref.read(selectedTagsProvider);
        final newSelectedTags = [...selectedTags, newTag];
        ref.read(selectedTagsProvider.notifier).state = newSelectedTags;
        widget.onSelected?.call(newSelectedTags);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTags = ref.watch(selectedTagsProvider);

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Topics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _availableTags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      List<String> newTags;
                      if (selected) {
                        newTags = [...selectedTags, tag];
                      } else {
                        newTags = selectedTags.where((t) => t != tag).toList();
                      }
                      ref.read(selectedTagsProvider.notifier).state = newTags;
                      widget.onSelected?.call(newTags);
                    },
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  showBottomSheet(
                    backgroundColor: Colors.grey[800],
                    context: context,
                    showDragHandle: true,
                    enableDrag: true,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Add Tags",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: _formTagKey,
                                child: TextFormField(
                                  controller: _tagController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a tag";
                                    }
                                    if (_availableTags.contains(value.capitalize())) {
                                      return "This tag already exists";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter tag",
                                    hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Cancel",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (_formTagKey.currentState!.validate()) {
                                      final newTag = _tagController.text.capitalize();
                                      _addNewTag(newTag);
                                      _tagController.clear();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Save",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  );
                },
                child: Text(
                  "Add Tags",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
