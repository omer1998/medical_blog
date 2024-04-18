import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
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

  List<String> selectedTopics = [];
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                                            color: AppPallete.borderColor),
                                    backgroundColor: selectedTopics.contains(e)
                                        ? AppPallete.gradient1
                                        : null,
                                    clipBehavior: Clip.antiAlias,
                                    label: Text(e))))
                            .toList())),
                BlogEditor(controller: titleController, hintText: "Title"),
                SizedBox(
                  height: 15,
                ),
                BlogEditor(controller: contentController, hintText: "Content"),
              ])),
        ));
  }
}
