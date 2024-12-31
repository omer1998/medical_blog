import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/add_custom_case_page.dart';
import 'package:medical_blog_app/features/case/pages/edit_custom_case_page2.dart';

class CustomCaseViewPage extends ConsumerStatefulWidget {
  final MyCase myCase;
  const CustomCaseViewPage({required this.myCase, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomCaseViewPageState();
}

class _CustomCaseViewPageState extends ConsumerState<CustomCaseViewPage> {
  @override
  Widget build(BuildContext context) {
    final contentJson = jsonDecode(widget.myCase.case_detail!);
    if (widget.myCase.case_detail == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text("No content")),
      );
    }

    final controller = QuillController(
        document: Document.fromJson(contentJson),
        selection: TextSelection.collapsed(offset: 0));
    return Scaffold(
      appBar: AppBar(
        title: Text("Case View"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditCustomCasePage(myCase: widget.myCase)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.1),
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.myCase.case_name.capitalize(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        child: Text(
                          widget.myCase.name![0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.myCase.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              DateFormat('MMMM d, yyyy').format(DateTime.parse(
                                  widget.myCase.created_at ??
                                      DateTime.now().toIso8601String())),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.myCase.tags != null &&
                      widget.myCase.tags!.isNotEmpty) ...[
                    Text(
                      'Topics',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.myCase.tags!
                            .map((tag) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withOpacity(0.2),
                                    side: BorderSide.none,
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    avatar: Icon(
                                      Icons.local_offer_outlined,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    label: Text(tag),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                      enableInteractiveSelection: false,
                      controller: controller, embedBuilders: [
                    ImageEmbedBuilder(),
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
