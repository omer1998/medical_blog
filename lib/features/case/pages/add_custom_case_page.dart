import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/custom_case_model.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/case/pages/widgets/topic_tags.dart';
import 'package:uuid/uuid.dart';

class AddCustomCasePage extends ConsumerStatefulWidget {
  const AddCustomCasePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCustomCasePageState();
}

class _AddCustomCasePageState extends ConsumerState<AddCustomCasePage> {
  final QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode titleFocus = FocusNode();
  final FocusNode contentFocus = FocusNode();

@override
  void initState() {
    // TODO: implement initState
    titleFocus.requestFocus();
    super.initState();
  }
void focusInputsWithErrors() {
    
    titleFocus.requestFocus();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
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
        final index = _controller.selection.baseOffset;
        final length = _controller.selection.extentOffset - index;
        
        if (length > 0) {
          _controller.replaceText(index, length, '', null);
        }
        
        _controller.document.insert(index, BlockEmbed.image(image.path));
        
        _controller.updateSelection(
          TextSelection.collapsed(offset: index + 1),
          ChangeSource.local,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to insert image. Please try again.')),
      );
    }
  }

  Future<void> _saveCase() async {
    if (!_formKey.currentState!.validate()) {
      focusInputsWithErrors();
      return;
    };
    if (_controller.document.isEmpty()) {
      contentFocus.requestFocus();
      return showSnackBar(context, "Please add some content to your case", backgroundColor: Colors.red[500], behavior: SnackBarBehavior.floating); 
    }
    if (selectedTags.isEmpty){
      return showSnackBar(context, "Please select at least one topic tag");
    }
    setState(() => _isLoading = true);
    
    try {

      final content =jsonEncode(_controller.document.toDelta().toJson());
      final user = (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState).user;
      print("content");
      print(content);
      print("user");
      print(user);
     
      // uploading case
      final res = await ref.read(caseControllerProvider).addCustomCase(
        CustomCaseModel(id: Uuid().v4(), caseName: _titleController.text.trim(), caseAuthorId: user.id, caseDetail: content, tags: selectedTags, structured: false)
      );
      res.fold((failure){
        showSnackBar(context, failure.message);
      }, (r){
        if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Case saved successfully!'), backgroundColor: Color.fromARGB(255, 122, 255, 126),),
        );
        ref.refresh(getCasesProvider);
        Navigator.pop(context);
      }
      });
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Failed to save case. Please try again.'), backgroundColor: Color.fromARGB(255, 255, 130, 121),),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: ClampingScrollPhysics(),
      
      child: SizedBox(
        
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    maxLines: null,
                    controller: _titleController,
                    focusNode: titleFocus,
                    decoration: const InputDecoration(
                      labelText: 'Case Title',
                      hintText: 'Enter a descriptive title for your case',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                child: Padding(
                  padding: const EdgeInsets.only(right:8.0, left: 8.0),
                  child: TopicTags(tags: ref.read(getCasesTagsProvider.notifier).state, onSelected: (tags) {
                    selectedTags = tags;
                  }),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: QuillToolbar.simple(
                        configurations: QuillSimpleToolbarConfigurations(
                          controller: _controller,
                          axis: Axis.horizontal,
                          multiRowsDisplay: false,
                          customButtons: [
                            QuillToolbarCustomButtonOptions(
                              icon: const Icon(Icons.image),
                              onPressed: _selectImage,
                              tooltip: 'Insert Image',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 350,
                      child: QuillEditor.basic(
                        focusNode: contentFocus,
                        configurations: QuillEditorConfigurations(
                          
                          controller: _controller,
                          autoFocus: false,
                          
                          showCursor: true,
                          embedBuilders: [ImageEmbedBuilder()],
                          placeholder: 'Start writing your case details...',
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveCase,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Save Case',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node,
      bool readOnly, bool inline, TextStyle textStyle) {
    final imageUrl = node.value.data;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('Failed to load image'),
                ),
              )
            : Image.file(
                File(imageUrl),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('Failed to load image'),
                ),
              ),
      ),
    );
  }
}
