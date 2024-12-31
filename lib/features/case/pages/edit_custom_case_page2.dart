import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/models/custom_case_model.dart';
import 'package:medical_blog_app/features/case/pages/add_custom_case_page.dart';
import 'package:medical_blog_app/features/case/repository/case_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditCustomCasePage extends ConsumerStatefulWidget {
  final MyCase myCase;

  const EditCustomCasePage({Key? key, required this.myCase}) : super(key: key);

  @override
  _EditCustomCasePageState createState() => _EditCustomCasePageState();
}

class _EditCustomCasePageState extends ConsumerState<EditCustomCasePage> {
  late QuillController _quillController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // track uploaded images for potential deletion
  List<String> uploadedImageUrls = [];

  List<String> _tags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize Quill Controller
    final contentJson = widget.myCase.case_detail != null
        ? jsonDecode(widget.myCase.case_detail!)
        : null;
    _quillController = QuillController(
        document:
            contentJson != null ? Document.fromJson(contentJson) : Document(),
        selection: TextSelection.collapsed(offset: 0));

    // Initialize other fields
    _titleController.text = widget.myCase.case_name;
    _tags = widget.myCase.tags ?? [];
  }

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

//  Future<Uint8List?> _compressImage(File file) async {
//     // Compress image to reduce file size
//     // notice the end result of compressing is just data; everything is data
//     // in order to upload this unit8list we need to either convert it to file
//     // or upload it in binary format
//     return await FlutterImageCompress.compressWithFile(
//       file.absolute.path,
//       minWidth: 800,
//       minHeight: 600,
//       quality: 85,
//     );
//   }
  Future<String?> _uploadImage(File imageFile) async {
    try {
      // Generate a unique filename
      final fileName =
          'case_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      // Upload to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('case_images')
          .upload(fileName, imageFile);

      // Get public URL
      final imageUrl = Supabase.instance.client.storage
          .from('case_images')
          .getPublicUrl(fileName);

      uploadedImageUrls.add(imageUrl);

      return imageUrl;
    } catch (e) {
      showSnackBar(context, 'Image upload failed: ${e.toString()}',
          backgroundColor: Colors.red);
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // Show loading indicator
      setState(() {
        _isLoading = true;
      });
      // final index = _quillController.selection.baseOffset;
      //     final length = _quillController.selection.extentOffset - index;

      // _quillController.replaceText(
      //       index,
      //       length,
      //       BlockEmbed.image(imageFile.path),
      //       null
      //     );
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     return;
      try {
        final imageUrl = await _uploadImage(imageFile);

        if (imageUrl != null) {
          // Insert image into Quill editor
          final index = _quillController.selection.baseOffset;
          final length = _quillController.selection.extentOffset - index;

          _quillController.replaceText(
              index, length, BlockEmbed.image(imageUrl), null);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _removeImagesFromStorage() async {
    try {
      // Remove uploaded images that are no longer in the document
      final currentDocumentImages = _extractImagesFromDocument();

      for (var imageUrl in uploadedImageUrls) {
        if (!currentDocumentImages.contains(imageUrl)) {
          // Extract the file name from the URL
          final fileName = imageUrl.split('/').last;

          // Delete from Supabase storage
          await Supabase.instance.client.storage
              .from('case_images')
              .remove([fileName]);
        }
      }
    } catch (e) {
      print('Error removing images: $e');
    }
  }

  List<String> _extractImagesFromDocument() {
    final List<String> imageUrls = [];

    // Iterate through document to find image embeds
    for (var op in _quillController.document.toDelta().operations) {
      if (op.attributes != null && op.attributes!['embed'] != null) {
        final embed = op.attributes!['embed'];
        if (embed is Map && embed['type'] == 'image') {
          imageUrls.add(embed['source']);
        }
      }
    }

    return imageUrls;
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a case title';
    }

    // Minimum length validation
    if (value.trim().length < 10) {
      return 'Title must be at least 10 characters long';
    }

    // Maximum length validation
    if (value.trim().length > 100) {
      return 'Title cannot exceed 100 characters';
    }

    // Prevent special character-only titles
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value.trim())) {
      return 'Title can only contain letters, numbers, and spaces';
    }

    return null;
  }

  String? _validateContent() {
    // Get the plain text content
    final plainText = _quillController.document.toPlainText().trim();

    if (_quillController.document.isEmpty()) {
      return 'Case content cannot be empty';
    }

    // Minimum word count
    final wordCount = plainText.split(RegExp(r'\s+')).length;
    if (wordCount < 50) {
      return 'Case content must be at least 50 words long';
    }

    // Maximum word count
    if (wordCount > 2000) {
      return 'Case content cannot exceed 2000 words';
    }

    return null;
  }

  Future<void> _updateCase() async {
    // Validate form and content
    if (!_formKey.currentState!.validate()) return;

    final contentError = _validateContent();
    if (contentError != null) {
      showSnackBar(context, contentError, backgroundColor: Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Remove images that are no longer in the document
      _removeImagesFromStorage();

      // Convert Quill document to JSON
      final deltaJson = _quillController.document.toDelta().toJson();
      final caseDetailJson = jsonEncode(deltaJson);

      // Prepare updated case data
      final updatedCase = widget.myCase.copyWith(
        case_name: _titleController.text.trim(),
        case_detail: caseDetailJson,
        tags: _tags,
      );
      final customCase = CustomCaseModel(
          id: widget.myCase.id,
          caseName: updatedCase.case_name,
          caseDetail: updatedCase.case_detail!,
          tags: updatedCase.tags ?? [],
          caseAuthorId: updatedCase.case_author,
          structured: false);
      print("case detail ${customCase.caseDetail}");
      // Call repository to update case
      final res =
          await ref.read(caseRepoProvider).updateCustomCase(myCase: customCase);
      res.fold((err) {
        print("error in updating case ${err.message}");
        showSnackBar(context, err.message, backgroundColor: Colors.red[500]);
      }, (r) {
        ref.refresh(getCasesProvider);
        print("updated case detail ${customCase.caseDetail}");
        showSnackBar(context, "Case updated successfully",
            backgroundColor: Colors.green);
        Navigator.pop(context);
      });
      // Show success message and pop navigation
      // showSnackBar(context, 'Case updated successfully');
      // context.pop(true);  // Return true to indicate successful update
    } catch (e) {
      print("error in updating case ${e.toString()}");
      showSnackBar(context, 'Error updating case: ${e.toString()}',
          backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Case'),
        actions: [
          if (_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _updateCase,
            ),
          IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () async{
                try {
                  print("removing image 1735529235912_36.jpg");
                await Supabase.instance.client.storage
              .from('case_images')
              .remove(["1735529235912_36.jpg"]);
                } catch (e) {
                  print("error in removing image ${e.toString()}");
                  showSnackBar(context, 'Error removing image: ${e.toString()}',
                      backgroundColor: Colors.red);
                }
              }),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // to be implemented
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Title Input with Advanced Validation
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Case Title',
                border: OutlineInputBorder(),
                helperText: 'Enter a descriptive title (10-100 characters)',
              ),
              validator: _validateTitle,
              maxLength: 100,
            ),
            SizedBox(height: 16),

            // Tag Management
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      labelText: 'Add Tags',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: _addTag,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Tags Display
            if (_tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                        ))
                    .toList(),
              ),
            SizedBox(height: 16),

            // Rich Text Editor with Image Upload
            QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                    controller: _quillController,
                    showAlignmentButtons: true,
                    showColorButton: true,
                    showBackgroundColorButton: true,
                    multiRowsDisplay: false,
                    customButtons: [
                  QuillToolbarCustomButtonOptions(
                    icon: const Icon(Icons.image),
                    tooltip: 'Upload Image',
                    onPressed: _pickImage,
                  )
                ])),

            QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                  controller: _quillController,
                  // readOnly: false,
                  padding: EdgeInsets.all(12),
                  embedBuilders: [
                    ImageEmbedBuilder(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
