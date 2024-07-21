import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  List<String> topics = [
    "Cardiology",
    "Respiratory",
    "Urinary",
    "Gastroenterology",
    "ECG",
    "Kidney",
    "MSK",
  ];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  List<String> selectedTopics = [];
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    _quillController.dispose();
  }

  File? image;
  void selectImage() async {
    File? file = await pickImage();
    if (file != null) {
      setState(() {
        image = file;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogSuccessState) {
          GoRouter.of(context).pushReplacementNamed("main");
          showSnackBar(context, "Blog uploaded successfully");
            
          
        } else if (state is BlogFailureState) {
          print(state.message);
          showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    // print(_quillController.document. toDelta().toJson());
                    if (image == null) {
                      showSnackBar(context, "Image is required");
                    }

                    if (_quillController.document.isEmpty()) {
                      showSnackBar(context, "Content is required");
                      // print(_quillController.document.toPlainText());
                    } else {
                      print(jsonEncode(
                          _quillController.document.toDelta().toJson()));
                    }
                    if (_formKey.currentState!.validate() &&
                        image != null &&
                        !_quillController.document.isEmpty()) {
                      print("--- id ---");
                      print("contenttttt");

                      print((BlocProvider.of<AppUserCubit>(context).state
                              as UserLoggedInState)
                          .user
                          .id);
                      BlocProvider.of<BlogBloc>(context).add(
                          BlogUploadBlogEvent(
                              authorId: (BlocProvider.of<AppUserCubit>(context)
                                      .state as UserLoggedInState)
                                  .user
                                  .id,
                              image: image!,
                              title: titleController.text.trim(),
                              content: jsonEncode(
                                  _quillController.document.toDelta().toJson()),
                              topics: selectedTopics));
                    }
                  },
                  icon: Icon(Icons.done_rounded))
            ],
          ),
          body: BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if (state is BlogLoadingState) {
                return Loader();
              }
              return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        image != null
                            ? GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    height: 165,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: DottedBorder(
                                    radius: Radius.circular(10),
                                    borderType: BorderType.RRect,
                                    color: AppPallete.borderColor,
                                    dashPattern: [10, 4],
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder_open,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Select Your Image",
                                            style: TextStyle(fontSize: 22),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 180,
                            child: GridView.count(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 0,
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 1,
                                children: topics
                                    .map((e) => GestureDetector(
                                        onTap: () => {
                                              if (!selectedTopics.contains(e))
                                                {
                                                  selectedTopics.add(e),
                                                }
                                              else
                                                {
                                                  selectedTopics.remove(e),
                                                },
                                              setState(() {}),
                                              print(selectedTopics)
                                            },
                                        child: Chip(
                                            side: selectedTopics.contains(e)
                                                ? BorderSide.none
                                                : BorderSide(
                                                    color:
                                                        AppPallete.borderColor),
                                            backgroundColor:
                                                selectedTopics.contains(e)
                                                    ? AppPallete.gradient1
                                                    : null,
                                            clipBehavior: Clip.antiAlias,
                                            label: Text(e))))
                                    .toList())),
                        BlogEditor(
                            controller: titleController, hintText: "Title"),
                        SizedBox(
                          height: 15,
                        ),
                        // BlogEditor(
                        //     controller: contentController, hintText: "Content"),

                        QuillToolbar.simple(
                          configurations: QuillSimpleToolbarConfigurations(
                            controller: _quillController,
                            multiRowsDisplay: false,
                            // embedButtons: FlutterQuillEmbeds.toolbarButtons(), // to imbed images or videos
                            sharedConfigurations:
                                const QuillSharedConfigurations(
                              locale: Locale('de'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: _quillController,
                            // embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                            autoFocus: true,
                            padding: EdgeInsets.all(10),
                            placeholder: "Start Writing your blog... ",
                            scrollable: true,
                            sharedConfigurations:
                                const QuillSharedConfigurations(
                              locale: Locale('de'),
                            ),
                          ),
                        ),
                      ]),
                    )),
              );
            },
          )),
    );
  }
}
