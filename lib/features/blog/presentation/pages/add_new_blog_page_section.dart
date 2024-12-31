import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/blog/controllers/blog_controllers.dart';
import 'package:medical_blog_app/features/case/pages/widgets/topic_chips_grid.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class AddNewBlogSection extends ConsumerStatefulWidget {
  final String userId;
  const AddNewBlogSection({required this.userId, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewBlogSectionState();
}

class _AddNewBlogSectionState extends ConsumerState<AddNewBlogSection> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  List<Section> sections = [Section()];
  List<Map<String, dynamic>> sectionImages = [];
  List<QuillController> _quilControllers = [];

  @override
  void dispose() {
    _titleController.dispose();
    // if (_quilControllers.isNotEmpty) {
    //   for (var controller in _quilControllers) {
    //     controller.dispose();
    //   }
    //   }

    super.dispose();
  }

  File? image;
  void selectImage() async {
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
                    setState(() {
                      image = img;
                      
                      Navigator.of(context).pop();
                    });
                  } else {
                    return null;
                  }
                },
                leading: Icon(Icons.camera),
                title: Text("Select From Camera")),
            ListTile(
                onTap: () async {
                  final img = await pickImageFromGallery();
                  if (img != null) {
                    setState(() {
                      image = img;
                     
                      Navigator.of(context).pop();
                    });
                  } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Blog Post')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Select Blog Image",
                                    style: TextStyle(fontSize: 22),
                                  )
                                ],
                              ),
                            )),
                      ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Select Topics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TopicTags(tags: [
                  "Cardiovascular",
                  "Respiratory",
                  "Digestive",
                  "Endocrine",
                  "Musculoskeletal",
                  "Neurological",
                  "Urological",
                  "Gastrointestinal",
                  "Genitourinary",
                  "Hematological",
                  "Lymphatic",
                  "Reproductive",
                  "Skin",
                  "Nervous",
                  "Immune",
                  "Infectious",
                  "Allergic",
                  
                  
                  "Neurological",
                  "Urological",
                  "Gastrointestinal",
                  "Genitourinary",
                  "Hematological",
                  "Lymphatic",
                  "Reproductive",
                ]),
                SizedBox(height: 20),
                TextFormField(
                  maxLines: null,
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Blog Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                ..._buildSectionFields(widget.userId),
                // ..._buildSectionFieldsCumstom(),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _addSection,
                      child: Text('Add Section'),
                    ),
                    ref.watch(blogControllerProvider)! ? CircularProgressIndicator() :
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 4, 75, 6)),
                      onPressed: () async {
                          // print(ref.read(selectedTagsProvider));

                        if (image == null) {
                          showSnackBar(context, "Select Image For Blog Please");
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          // Convert sections to JSON
                          final blogId = Uuid().v4();
      // sections.last.content = jsonEncode(_quilControllers.last.document.toDelta().toJson()) ;

                          // sections.forEach((e)=> print(e.toString()));
                          
                          await ref.read(blogControllerProvider.notifier).uploadBlog(
                            selectedTags: ref.read(selectedTagsProvider),
                              sections, blogId, context,
                              userId: widget.userId,
                              title: _titleController.text.trim(),
                              content: "",
                              blogImg: image);
                          // Submit data to the database
                          // _submitBlogPost(_titleController.text, contentJson);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSectionFieldsCumstom() {
    List<Widget> sectionFields = [];
    final quilController = QuillController.basic();
    _quilControllers.add(quilController);
    for (var i = 0; i < sections.length; i++) {
      sectionFields.add(
        Column(
          children: [
            SizedBox(height: 16),
            TextFormField(
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Section title'),
              onChanged: (value) {
                sections[i].title = value;
              },
            ),
            SizedBox(height: 10),
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _quilControllers[i],
                multiRowsDisplay: false,
                // embedButtons: FlutterQuillEmbeds.toolbarButtons(), // to imbed images or videos
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _quilControllers[i],
                // embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                autoFocus: true,
                padding: EdgeInsets.all(10),
                placeholder: "Enter Content... ",
                scrollable: true,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
            SizedBox(height: 16),
            Column(
                children: sections[i]
                    .imagesFile
                    .map((e) => Container(
                        width: 100,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(e)))
                    .toList()),
            SizedBox(height: 7),
            ElevatedButton(
              onPressed: () async {
                final image = await pickImageFromGallery();
                if (image == null) {
                  showSnackBar(context, "Image not selected");
                  return;
                }
                // final imageUrl  = await ref.read(blogControllerProvider).upLoadBlogImage("ijijiefjiejfdcmkd", i, image!);
                // print("image url: $imageUrl");
                setState(() {
                  sections[i].imagesFile.add(image);
                  _quilControllers = [];
                });
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      );
    }
    return sectionFields;
  }

  List<Widget> _buildSectionFields(String userId) {
    List<Widget> sectionFields = [];
    for (var i = 0; i < sections.length; i++) {
      sectionFields.add(
        Column(
          children: [
            SizedBox(height: 16),
            TextFormField(
              maxLines: null,
              // validator: (value) {
              //   if (value == null || value.isEmpty){
              //     return 'Please enter a title';
              //   }
              //   return null;
              // },
              decoration: InputDecoration(labelText: 'Section Title'),
              onChanged: (value) {
                sections[i].title = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a content';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Section Content'),
              minLines: 3,
              maxLines: null,
              onChanged: (value) {
                sections[i].content = value;
              },
            ),
            SizedBox(height: 16),
            Column(
                children:
                    sections[i].imagesFile.map((e) => Container(
                      clipBehavior: Clip.hardEdge,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle
                      ),
                      child: Image.file(e))).toList()),
            SizedBox(height: 7),
            ElevatedButton(
              onPressed: () async {
                final image = await pickImageFromGallery();
                if (image == null) {
                  showSnackBar(context, "Image not selected");
                  return;
                }
                // final imageUrl  = await ref.read(blogControllerProvider).upLoadBlogImage("ijijiefjiejfdcmkd", i, image!);
                // print("image url: $imageUrl");
                setState(() {
                  sections[i].imagesFile.add(image);
                });
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      );
    }
    return sectionFields;
  }

  void _addSection() {
    print("quil content");
    // print(_quilControllers.length);
    // print(_quilControllers.last.document.isEmpty());
    // print(_quilControllers.last.document.toPlainText().isNotEmpty);
    // && !_quilControllers.last.document.isEmpty()
    if (_formKey.currentState!.validate() ) {
      // sections.last.content = jsonEncode(_quilControllers.last.document.toDelta().toJson()) ;
      setState(() {
        sections.add(Section());
      });
    }
  }

  // Future<String> _uploadImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     // Upload the file to Firebase Storage or another service
  //     return "";
  //   } else {
  //     throw Exception('No image selected');
  //   }
  // }
}

class Section {
  String title;
  String content;
  List<String> images = [];
  List<File> imagesFile = [];

  Section([this.title = '', this.content = '']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'images': images,
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return "title: $title, content: $content";
  }
}
