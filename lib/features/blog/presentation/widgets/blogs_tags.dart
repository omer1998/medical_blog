import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/blog/controllers/blog_controllers.dart';

class BlogTags extends ConsumerStatefulWidget {
  final List<String> tags;
  final Function(List<String>) onTagsChanged;
  const BlogTags({super.key, 
  required this.tags,
  required this.onTagsChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogTagsState();
}

class _BlogTagsState extends ConsumerState<BlogTags> {
List<String> selectedTags = [];
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  // Initial set of medical tags

  void _addNewTag(List<String> selectedTags) {
    final newTag = _tagController.text.trim();
    if (newTag.isNotEmpty && !widget.tags.contains(newTag)) {
      
      setState(() {
        widget.tags.insert(0, newTag);
        ref.read(selectedBlogTagsProvider.notifier).state.insert(0,newTag);
        
      });
      _tagController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppPallete.backgroundColor,
                AppPallete.gradient2.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppPallete.gradient1.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blog Tags',
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select existing tags or add new ones',
                style: TextStyle(
                  color: AppPallete.whiteColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppPallete.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppPallete.gradient1.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _tagController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a new tag...',
                          hintStyle: TextStyle(
                            color: AppPallete.whiteColor.withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: AppPallete.backgroundColor,
                        ),
                        onSubmitted: (_) => _addNewTag(ref.read(allAvailableBlogTagsProvider.notifier).state),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppPallete.gradient1.withOpacity(0.2),
                          AppPallete.gradient2.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _addNewTag(ref.read(allAvailableBlogTagsProvider.notifier).state),
                      icon: Icon(
                        Icons.add,
                        color: AppPallete.whiteColor,
                      ),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.tags.map((tag) {
                  final isSelected = ref.read(selectedBlogTagsProvider).contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        
                        if (selected) {
                          ref.read(selectedBlogTagsProvider.notifier).state.add(tag);
                        } else {
                          ref.read(selectedBlogTagsProvider.notifier).state.remove(tag);
                        }
                        print("selected tags: ${ref.read(selectedBlogTagsProvider.notifier).state}");
                      });
                        widget.onTagsChanged(ref.read(selectedBlogTagsProvider.notifier).state);

                    },
                    backgroundColor: AppPallete.backgroundColor,
                    selectedColor: AppPallete.gradient1.withOpacity(0.3),
                    checkmarkColor: AppPallete.whiteColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppPallete.whiteColor
                          : AppPallete.whiteColor.withOpacity(0.7),
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? AppPallete.gradient1
                            : AppPallete.gradient1.withOpacity(0.2),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
