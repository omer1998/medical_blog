import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/repository/case_repository.dart';

class EditCustomCasePage extends ConsumerStatefulWidget {
  final MyCase myCase;

  const EditCustomCasePage({
    Key? key, 
    required this.myCase
  }) : super(key: key);

  @override
  _EditCustomCasePageState createState() => _EditCustomCasePageState();
}

class _EditCustomCasePageState extends ConsumerState<EditCustomCasePage> {
  late QuillController _quillController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize Quill Controller
    final contentJson = widget.myCase.case_detail != null 
      ? jsonDecode(widget.myCase.case_detail!) 
      : null;
    _quillController = QuillController(
      document: contentJson != null 
        ? Document.fromJson(contentJson) 
        : Document(),
      selection: TextSelection.collapsed(offset: 0)
    );

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

  Future<void> _updateCase() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Convert Quill document to JSON
      final deltaJson = _quillController.document.toDelta().toJson();
      final caseDetailJson = jsonEncode(deltaJson);

      // Prepare updated case data
      final updatedCase = widget.myCase.copyWith(
        case_name: _titleController.text.trim(),
        case_detail: caseDetailJson,
        tags: _tags,
      );

      // Call repository to update case
      // await ref.read(caseRepoProvider).updateCase(updatedCase);

      // Show success message and pop navigation
      // showSnackBar(context, 'Case updated successfully');
      // context.pop(true);  // Return true to indicate successful update
    } catch (e) {
      showSnackBar(
        context, 
        'Error updating case: ${e.toString()}', 
        backgroundColor: Colors.red
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Case'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateCase,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Title Input
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Case Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a case title';
                }
                return null;
              },
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
                children: _tags.map((tag) => Chip(
                  label: Text(tag),
                  onDeleted: () => _removeTag(tag),
                )).toList(),
              ),
            SizedBox(height: 16),

            // Rich Text Editor
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _quillController,
                multiRowsDisplay: false,
                showAlignmentButtons: true,
                showBackgroundColorButton: true,
                showColorButton: true,
              ),
              
            ),
            QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _quillController,
                autoFocus: true,
                padding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}