import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/storage.dart';
import 'package:medical_blog_app/core/utils/pick_image.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/profile/controller/profile_controller.dart';
import 'package:medical_blog_app/features/profile/repository/profile_repository.dart';
import 'package:medical_blog_app/features/profile/widget/appbar_widget.dart';
import 'package:medical_blog_app/features/profile/widget/button_widget.dart';
import 'package:medical_blog_app/features/profile/widget/profile_widget.dart';
import 'package:medical_blog_app/features/profile/widget/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? image;
  String? name;
  String? email;
  String? about;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          image == null
              ? ProfileWidget(
                  imagePath: widget.user.img_url ?? "",
                  isEdit: true,
                  onClicked: () async {
                    image = await pickImage();
                    setState(() {});
                  },
                )
              : ProfileWidget(
                  imagePath: "user.imagePath",
                  imageFile: image,
                  isEdit: true,
                  onClicked: () async {
                    image = await pickImage();
                  },
                ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: widget.user.name,
            onChanged: (value) {
              name = value;
            },
          ),
          // const SizedBox(height: 24),
          // TextFieldWidget(
          //   label: 'Email',
          //   text: widget.user.email,
          //   onChanged: (email) {
          //     email = email;

          //   },
          // ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'About',
            text: widget.user.about ??
                "Talk about yourself a little bit ... a little ...",
            maxLines: 5,
            onChanged: (value) {
              about = value;
            },
          ),
          const SizedBox(height: 24),
          Consumer(
            builder: (_, WidgetRef ref, __) {
              bool isLoading = ref.watch(profileControllerProvider);
              final user = (BlocProvider.of<AppUserCubit>(context).state
                      as UserLoggedInState)
                  .user;
                  UserModel updatedUser = user as UserModel;
              return isLoading
                  ? Loader()
                  : ButtonWidget(
                      text: "Update",
                      onClicked: () async {
                        if (image != null) {
                          try {
                            await ref
                                .read(profileControllerProvider.notifier)
                                .updateImgUrl(
                                    image!, user as UserModel, context);
                            showSnackBar(context, "Image updated Successfully");
                            
                          } catch (e) {
                            showSnackBar(context, e.toString());
                          }
                          //    ref.read(saveProfileImgProvider.call({"img": image!, "userId": user.id})).when(data:(data) {
                          //     showSnackBar(context, "Image Updated Successfully");

                          //   }, error:(error, stackTrace) {
                          //     showSnackBar(context, error.toString());
                          //   }, loading:() {
                          //     return Loader();
                          //   },);
                        }
                        if (name != null ){
                          updatedUser = updatedUser.copyWith(name: name);
                        }else{
                          updatedUser = updatedUser.copyWith(name: user.name);
                        }
                        // if (email != null ){
                        //   updatedUser = updatedUser.copyWith(email: email);
                        // }else {
                        //   updatedUser = updatedUser.copyWith(email: user.email);
                        // }
                        if (about != null){
                          updatedUser = updatedUser.copyWith(about: about);
                        }else{
                          updatedUser = updatedUser.copyWith(about: user.about);
                        }

                        // print("name and about section");
                        // print(name);
                        // print(about);
                        print("updated user");
                        print(updatedUser.toString());
                        await ref.read(profileControllerProvider.notifier).updateProfileInfo(updatedUser, context);
                        // print("user data that is saved locally");
                        // await ref.read(profileRepositoryProvider).showUserFromLocalDb();
                      });
            },
          )
        ],
      ),
    );
  }
}
