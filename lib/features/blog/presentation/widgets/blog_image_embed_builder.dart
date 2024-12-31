import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart';

class BlogImageEmbedBuilder extends EmbedBuilder{

  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    print(node.value.data);
    String imageFile = node.value.data;
    if (imageFile.startsWith('http')) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          height: 250,
          imageUrl: imageFile,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress)),
          errorWidget: (context, error, stackTrace){
            print("error");
            print(error);
             return const Center(
            child: Text('Failed to load image'),
          );
          } 
        ),
      );
    }else {
      return Image.file(File(imageFile), fit: BoxFit.contain);
    }
  }

  @override
  // TODO: implement key
  String get key => BlockEmbed.imageType;

}