import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill/flutter_quill.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/services/blog_image_service.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/blog/controllers/blog_controllers.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blogs_tags.dart';
import 'package:medical_blog_app/features/main/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/blog_image_embed_builder.dart';

class AddNewBlogPage extends ConsumerStatefulWidget {
  final List<String> availableTags;
  const AddNewBlogPage({super.key, required this.availableTags});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends ConsumerState<AddNewBlogPage> {
  final _formKey = GlobalKey<FormState>();
  final QuillController _quillController = QuillController.basic();
  final TextEditingController titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> selectedTags = [];
  File? coverImage;
  bool isLoading = false;
  bool blogPublished = false;

  List<String> blogImagesPath = [];
  @override
  void dispose() async {
    // print("disposing");
    // print("blogUploaded : ${blogPublished}");
    titleController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    // blogPublished == false
    //     ? await BlogImageService.removeBlogImages(imageUrls: blogImagesPath)
    //     : null;
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPallete.gradient1.withOpacity(0.15),
            AppPallete.backgroundColor.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.gradient1.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New Blog Post',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient1,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Share your medical knowledge and insights with the community',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPallete.whiteColor.withOpacity(0.8),
                  fontSize: 16,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPallete.backgroundColor,
            AppPallete.gradient1.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppPallete.gradient1.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: titleController,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor,
          height: 1.5,
        ),
        decoration: InputDecoration(
          labelText: 'Blog Title',
          labelStyle: TextStyle(
            color: AppPallete.whiteColor.withOpacity(0.8),
            fontSize: 16,
          ),
          hintText: 'Enter a descriptive title for your blog post',
          hintStyle: TextStyle(
            color: AppPallete.whiteColor.withOpacity(0.5),
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppPallete.gradient1.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
    );
  }

  void _selectImage() async {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                onTap: () async {
                  final img = await pickImageFromCamera();
                  if (img != null) {
                    await _insertImage(img);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();

                    return null;
                  }
                },
                leading: Icon(Icons.camera),
                title: Text("Select From Camera")),
            ListTile(
                onTap: () async {
                  final img = await pickImageFromGallery();
                  if (img != null) {
                    await _insertImage(img);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();

                    return null;
                  }
                },
                leading: Icon(Icons.file_copy),
                title: Text("Select From Gallery")),
          ],
        );
      },
    );
  }

  Future<void> _insertImage(File? image) async {
    try {
      if (image != null) {
        final index = _quillController.selection.baseOffset;
        final length = _quillController.selection.extentOffset - index;

        if (length > 0) {
          _quillController.replaceText(index, length, '', null);
        }

        _quillController.document.insert(index, BlockEmbed.image(image.path));

        _quillController.updateSelection(
          TextSelection.collapsed(offset: index + 1),
          ChangeSource.local,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to insert image. Please try again.')),
      );
    }
  }

  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppPallete.gradient1.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPallete.backgroundColor,
            AppPallete.gradient1.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppPallete.backgroundColor.withOpacity(0.7),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(
                  color: AppPallete.gradient1.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                  controller: _quillController,
                  multiRowsDisplay: false,
                  color: AppPallete.transparentColor,
                  customButtons: [
                    QuillToolbarCustomButtonOptions(
                      icon: Icon(
                        Icons.add_photo_alternate_rounded,
                      ),
                      onPressed: () => addBlogImage(),
                      tooltip: "Add Image",
                    )
                  ]),
            ),
          ),
          Container(
            height: 400,
            padding: const EdgeInsets.all(24),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _quillController,
                scrollable: true,
                embedBuilders: [
                  BlogImageEmbedBuilder(),
                ],
                autoFocus: false,
                placeholder: 'Start writing your blog post...',
                padding: EdgeInsets.zero,
                customStyles: DefaultStyles(
                  h1: DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 32,
                      color: AppPallete.whiteColor,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                    const VerticalSpacing(16, 0),
                    const VerticalSpacing(0, 16),
                    null,
                  ),
                  h2: DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 24,
                      color: AppPallete.whiteColor,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                    const VerticalSpacing(16, 0),
                    const VerticalSpacing(0, 16),
                    null,
                  ),
                  h3: DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 20,
                      color: AppPallete.whiteColor,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                    const VerticalSpacing(16, 0),
                    const VerticalSpacing(0, 16),
                    null,
                  ),
                  placeHolder: DefaultTextBlockStyle(
                    TextStyle(
                      color: AppPallete.whiteColor.withOpacity(0.5),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    const VerticalSpacing(0, 0),
                    const VerticalSpacing(0, 0),
                    null,
                  ),
                  paragraph: DefaultTextBlockStyle(
                    TextStyle(
                      color: AppPallete.whiteColor.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    const VerticalSpacing(0, 0),
                    const VerticalSpacing(0, 0),
                    null,
                  ),
                  lists: DefaultListBlockStyle(
                    TextStyle(
                      color: AppPallete.whiteColor.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    const VerticalSpacing(0, 0),
                    const VerticalSpacing(0, 0),
                    null,
                    null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImageSelector() {
    return GestureDetector(
      onTap: selectCoverImage,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppPallete.backgroundColor,
              AppPallete.gradient1.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppPallete.gradient1.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: coverImage != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      coverImage!,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppPallete.backgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => setState(() => coverImage = null),
                        icon: Icon(
                          Icons.close,
                          color: AppPallete.whiteColor,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                height: 200,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppPallete.backgroundColor,
                            AppPallete.gradient1.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Add Cover Image',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppPallete.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recommended: 1600x900px',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppPallete.whiteColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> selectCoverImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        coverImage = File(imageFile.path);
      });
    }
  }

  void _publishBlog() {
    print("publishing");
    if (!_formKey.currentState!.validate()) return;

    if (selectedTags.isEmpty) {
      showSnackBar(context, 'Please select at least one topic');
      return;
    }

    if (coverImage == null) {
      showSnackBar(context, 'Please select a cover image');
      return;
    }

    final postContent =
        jsonEncode(_quillController.document.toDelta().toJson());

    if (_quillController.document.isEmpty()) {
      showSnackBar(context, 'Please add some content to your blog');
      return;
    }
    final images = _quillController.document.toDelta().toJson();
    print("images : $images");
    final appUser = context.read<AppUserCubit>().state as UserLoggedInState;
    if (appUser.user == null) return;

    print("Post content");
    print(postContent);
    BlocProvider.of<BlogBloc>(context).add(
      BlogUploadBlogEvent(
        title: titleController.text,
        content: postContent,
        image: coverImage!,
        topics: selectedTags,
        authorId: appUser.user.id,
      ),
    );
    ref.read(selectedBlogTagsProvider.notifier).state = [];
  }

  addBlogImage() async {
    try {
      File? image = await pickImageFromGallery();
      if (image != null) {
        // upload image to supabase storage and get its url
        final appUser =
            (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
                .user;
        final imageUrl = await BlogImageService.uploadBlogImage(
            urlPath: appUser.name, imagePath: image.path);

        setState(() {
          blogImagesPath.add(imageUrl);
          final imagePath = image.path;

          final offset = _quillController.selection.base.offset;
          _quillController.document.insert(offset, BlockEmbed.image(imageUrl));
        });
      }
    } catch (e) {
      showSnackBar(context, "Failed to add image",
          backgroundColor: Colors.red[500],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser =
        (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
            .user;

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        elevation: 0,
        title: Text(
          'New Blog Post',
          style: TextStyle(
            color: AppPallete.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppPallete.whiteColor),
        actions: [
          BlocBuilder<BlogBloc, BlogState>(builder: (context, state) {
            if (state is BlogLoadingState) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(
                  color: AppPallete.gradient1,
                  strokeWidth: 2,
                ),
              );
            }
            return Row(
              children: [
                // TextButton(
                //     onPressed: () async {
                //       //   print("path");
                //       //   print("${appUser.name.trim()}/${"https://unhkwlvbdldgqnxmfpaw.supabase.co/storage/v1/object/public/blog_image/omer%20faris%20/1734829886680_36.jpg".split("/").last}");
                //       //  await BlogImageService.removeBlogImages(imageUrls:["${appUser.name.trim()}/${"https://unhkwlvbdldgqnxmfpaw.supabase.co/storage/v1/object/public/blog_image/omer%20faris%20/1734829886680_36.jpg".split("/").last}"] );
                //       try {
                //         final supabaseStorage =
                //             Supabase.instance.client.storage;

                //         await supabaseStorage.from("blog_image").remove([
                //           "omer_faris/1734829886680_36.jpg"
                //         ]);
                //       } catch (e) {
                //         showSnackBar(
                //             context, "Error removing images ${e.toString()}",
                //             backgroundColor: Colors.red[500],
                //             behavior: SnackBarBehavior.floating,
                //             duration: const Duration(seconds: 5));
                //       }
                //     },
                //     child: Text("remove images")),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: TextButton.icon(
                    onPressed: _publishBlog,
                    icon: Icon(
                      Icons.publish,
                      color: AppPallete.gradient1,
                      size: 20,
                    ),
                    label: Text(
                      'Publish',
                      style: TextStyle(
                        color: AppPallete.gradient1,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      backgroundColor: AppPallete.gradient1.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppPallete.gradient1.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogSuccessState) {
            setState(() {
              blogPublished = true;
            });
            showSnackBar(context, "Blog published successfully",
                backgroundColor: Colors.green[500],
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3));
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainPage()),
                (Route<dynamic> route) => true);
          } else if (state is BlogFailureState) {
            showSnackBar(context, state.message,
                backgroundColor: Colors.red[500],
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5));
          }
        },
        builder: (context, state) => Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     AppPallete.backgroundColor,
              //     AppPallete.gradient2.withOpacity(0.05),
              //   ],
              // ),
              ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildCoverImageSelector(),
                  const SizedBox(height: 32),
                  _buildTitleField(),
                  const SizedBox(height: 32),
                  BlogTags(
                    tags: widget.availableTags,
                    onTagsChanged: (tags) {
                      selectedTags = tags;
                      print(selectedTags);
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildEditor(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
