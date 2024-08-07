import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;
  final File? imageFile;

  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      this.isEdit = false,
      required this.onClicked,
      this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: InkWell(onTap: onClicked, child: buildEditIcon(color)),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    // final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
          color: Colors.transparent,
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                  imageUrl: imagePath,  //"${imagePath}?${DateTime.now().microsecond.toString()}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
          // Ink.image(
          //   image: image,
          //   fit: BoxFit.cover,
          //   width: 128,
          //   height: 128,
          //   child: InkWell(onTap: onClicked),
          // ),
          ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
