import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/profile/controller/credential_controller.dart';
import 'package:medical_blog_app/features/profile/controller/profile_controller.dart';
import 'package:medical_blog_app/features/profile/widget/appbar_widget.dart';
import 'package:medical_blog_app/features/profile/widget/button_widget.dart';
import 'package:medical_blog_app/features/profile/widget/profile_widget.dart';
import 'package:medical_blog_app/features/profile/widget/textfield_widget.dart';
import 'package:medical_blog_app/features/profile/widget/credentials_section.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? image;
  String? name;
  String? about;
  String? title;
  String? specialization;
  String? currentPosition;
  String? institution;
  List<String> expertise = [];
  final TextEditingController _expertiseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    expertise = widget.user.expertise == null ? [] : widget.user.expertise!.toList();
  }

  @override
  void dispose() {
    _expertiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, null, "Edit Profile"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          image == null
              ? ProfileWidget(
                  imagePath: widget.user.img_url ?? "",
                  isEdit: true,
                  onClicked: () async {
                    image = await pickImageFromCamera();
                    setState(() {});
                  },
                )
              : ProfileWidget(
                  imagePath: "user.imagePath",
                  imageFile: image,
                  isEdit: true,
                  onClicked: () async {
                    image = await pickImageFromCamera();
                  },
                ),
          const SizedBox(height: 24),
          
          // Basic Information Section
          buildSectionTitle('Basic Information'),
          TextFieldWidget(
            label: 'Full Name',
            text: widget.user.name,
            onChanged: (value) => name = value,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'About',
            text: widget.user.about ?? "Talk about yourself a little bit ...",
            maxLines: 5,
            onChanged: (value) => about = value,
          ),
          const SizedBox(height: 24),

          // Professional Information Section
          buildSectionTitle('Professional Information'),
          TextFieldWidget(
            label: 'Professional Title (e.g., Dr., Prof.)',
            text: widget.user.title ?? '',
            onChanged: (value) => title = value,
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            label: 'Specialization',
            text: widget.user.specialization ?? '',
            onChanged: (value) => specialization = value,
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            label: 'Current Position',
            text: widget.user.currentPosition ?? '',
            onChanged: (value) => currentPosition = value,
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            label: 'Institution',
            text: widget.user.institution ?? '',
            onChanged: (value) => institution = value,
          ),
          const SizedBox(height: 24),

          // Professional Credentials Section
          CredentialsSection(userId: widget.user.id),
          const SizedBox(height: 24),

          // Areas of Expertise Section
          buildSectionTitle('Areas of Expertise'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expertiseController,
                  decoration: const InputDecoration(
                    labelText: 'Add expertise',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_expertiseController.text.isNotEmpty) {
                    setState(() {
                      expertise.add(_expertiseController.text);
                      _expertiseController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: expertise.map((exp) {
              return Chip(
                label: Text(exp),
                onDeleted: () {
                  setState(() {
                    expertise.remove(exp);
                  });
                },
                backgroundColor: Colors.blue.withOpacity(0.1),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Update Button
          Consumer(
            builder: (_, WidgetRef ref, __) {
              bool isLoading = ref.watch(profileControllerProvider);
              final user = (BlocProvider.of<AppUserCubit>(context).state
                      as UserLoggedInState)
                  .user;
              UserModel updatedUser = user as UserModel;

              return isLoading
                  ? const Loader()
                  : ButtonWidget(
                      text: "Update Profile",
                      onClicked: () async {
                        if (image != null) {
                          try {
                            await ref
                                .read(profileControllerProvider.notifier)
                                .updateImgUrl(image!, user as UserModel, context);
                            showSnackBar(context, "Image updated Successfully");
                          } catch (e) {
                            showSnackBar(context, e.toString());
                          }
                        }

                        // Update user information
                        updatedUser = updatedUser.copyWith(
                          name: name ?? user.name,
                          about: about ?? user.about,
                          title: title ?? user.title,
                          specialization: specialization ?? user.specialization,
                          currentPosition: currentPosition ?? user.currentPosition,
                          institution: institution ?? user.institution,
                          expertise: expertise,
                        );

                        await ref
                            .read(profileControllerProvider.notifier)
                            .updateProfileInfo(updatedUser, context);
                      },
                    );
            },
          ),
          // Consumer(
          //   builder: (BuildContext context, WidgetRef ref, Widget? child) { 
          //     return IconButton(
          //     icon: const Icon(Icons.emoji_emotions),
          //     onPressed: () async {
          //      try {
          //        await ref.read(credentialControllerProvider.notifier).addCredential(userId: widget.user.id, title: "MBCHB", institution: "Al Kindy College Of Medicine", year: 2022.toString(), type: "Degree", context: context);
          //        //showSnackBar(context, "Added Successfully");
                 
          //      } catch (e) {
          //       print(e.toString());
          //       showSnackBar(context, e.toString());
          //      } 
          //     },
          //   );
          //    },
            
          // ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
