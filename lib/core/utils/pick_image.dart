import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return null;
    }
    return File(xFile.path);
  } catch (e) {
    return null;
  }
}
