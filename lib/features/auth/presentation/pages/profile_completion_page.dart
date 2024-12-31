import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_field.dart';

class ProfileCompletionPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ProfileCompletionPage(),
      );

  const ProfileCompletionPage({super.key});

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  final specializationController = TextEditingController();
  final institutionController = TextEditingController();
  final _expertiseController = TextEditingController();
  File? profileImage;
  bool isPickingImage = false;
  List<String> selectedExpertise = [];
  final formKey = GlobalKey<FormState>();

  // Add controllers for social links
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final linkedinController = TextEditingController();
  bool isUploading = false;

  // Pre-defined list of medical specialties
  final List<String> expertiseOptions = [
    // Add more as needed
  ];

  @override
  void dispose() {
    titleController.dispose();
    aboutController.dispose();
    specializationController.dispose();
    institutionController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    linkedinController.dispose();
    _expertiseController.dispose();
    super.dispose();
  }

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
                      profileImage = img;

                      
                    });
                    
                  } 
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.camera),
                title: Text("Select From Camera")),
            ListTile(
                onTap: () async {
                  final img = await pickImageFromGallery();
                  if (img != null) {
                    setState(() {
                      profileImage = img;
                    });
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

  void updateProfile() {
    
    if (!formKey.currentState!.validate()) return;

    // Create social links map
    final socialLinks = <String, String>{};
    if (facebookController.text.isNotEmpty) {
      socialLinks['facebook'] = facebookController.text.trim();
    }
    if (instagramController.text.isNotEmpty) {
      socialLinks['instagram'] = instagramController.text.trim();
    }
    if (twitterController.text.isNotEmpty) {
      socialLinks['twitter'] = twitterController.text.trim();
    }
    if (linkedinController.text.isNotEmpty) {
      socialLinks['linkedin'] = linkedinController.text.trim();
    }
    if (profileImage != null) {
      
      BlocProvider.of<AuthBloc>(context).add(
            UpdateProfileEvent(
              name: "omer faris 1",
              imageFile: profileImage!,
              title: titleController.text.trim(),
              about: aboutController.text.trim(),
              specialization: specializationController.text.trim(),
              institution: institutionController.text.trim(),
              expertise: expertiseOptions,
              socialLinks: socialLinks,
            ),
          );
    } else {
      
      showSnackBar(
        context,
        "Please select a profile image",
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 3),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text(
          'Complete Your Profile',
          style: TextStyle(color: AppPallete.whiteColor),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            GoRouter.of(context).goNamed('main');
          }
          if (state is ProfileUpdateFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileUpdateLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Step indicator
                  Text(
                    'Step 2 of 2',
                    style: TextStyle(
                      color: AppPallete.gradient1,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profile Image
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: isPickingImage == false
                            ? () {
                                selectImage();
                              }
                            : null,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                          child: profileImage == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppPallete.gradient1,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: profileImage == null
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppPallete.gradient1,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      profileImage = null;
                                    });
                                  },
                                  child: Icon(Icons.close, size: 20),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Professional Information
                  AuthField(
                    controller: titleController,
                    hintText: 'Professional Title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your professional title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: aboutController,
                    hintText: 'About You',
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please tell us about yourself';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: specializationController,
                    hintText: 'Specialization',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your specialization';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: institutionController,
                    hintText: 'Institution',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your institution';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Expertise Selection
                  Text(
                    'Areas of Expertise',
                    style: TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expertiseController,
                          decoration: const InputDecoration(
                            labelText: 'Add Expertise',
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   if (value != null && value.isEmpty) {
                          //     return "This field is required";
                          //   } else {
                          //     return null;
                          //   }
                          // },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton.filled(
                            onPressed: () {
                              if (_expertiseController.text.trim().isNotEmpty) {
                                if (!expertiseOptions.contains(
                                    _expertiseController.text.trim())) {
                                  setState(() {
                                    expertiseOptions
                                        .add(_expertiseController.text.trim());
                                    _expertiseController.clear();
                                  });
                                } else {
                                  showSnackBar(context, "Already Exist");
                                }
                              }
                            },
                            icon: Icon(Icons.add)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  expertiseOptions.isEmpty
                      ? Container()
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: expertiseOptions.map((expertise) {
                            return Chip(
                              label: Text(expertise),
                              onDeleted: () {
                                setState(() {
                                  expertiseOptions.remove(expertise);
                                });
                              },
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 24),

                  // Social Links Section
                  Text(
                    'Social Media Links',
                    style: TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Facebook
                  AuthField(
                    controller: facebookController,
                    hintText: 'Facebook Profile URL',
                    prefixIcon: Icon(Icons.facebook, color: Colors.blue),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.contains('facebook.com')) {
                          return 'Please enter a valid Facebook URL';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Instagram
                  AuthField(
                    controller: instagramController,
                    hintText: 'Instagram Profile URL',
                    prefixIcon: Icon(Icons.camera_alt, color: Colors.pink),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.contains('instagram.com')) {
                          return 'Please enter a valid Instagram URL';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Twitter/X
                  AuthField(
                    controller: twitterController,
                    hintText: 'Twitter/X Profile URL',
                    prefixIcon: Icon(Icons.alternate_email,
                        color: AppPallete.whiteColor),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.contains('twitter.com') &&
                            !value.contains('x.com')) {
                          return 'Please enter a valid Twitter/X URL';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // LinkedIn
                  AuthField(
                    controller: linkedinController,
                    hintText: 'LinkedIn Profile URL',
                    prefixIcon: Icon(Icons.work, color: Colors.blue),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.contains('linkedin.com')) {
                          return 'Please enter a valid LinkedIn URL';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:()=> updateProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Complete Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skip button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => true,
                      );
                    },
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        color: AppPallete.whiteColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
