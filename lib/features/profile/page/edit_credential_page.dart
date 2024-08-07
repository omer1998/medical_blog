import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/profile/controller/profile_controller.dart';
import 'package:medical_blog_app/features/profile/widget/appbar_widget.dart';
import 'package:medical_blog_app/features/profile/widget/button_widget.dart';
import 'package:medical_blog_app/features/profile/widget/textfield_widget.dart';

class EditCredentialPage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditCredentialPage({required this.user, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCredentialPageState();
}

class _EditCredentialPageState extends ConsumerState<EditCredentialPage> {
  bool isObscured = true;
  String? email;
    String? password;
  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(profileControllerProvider);

    
    return Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 32),
              Text("Edit Credential",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              TextFieldWidget(
                label: "Email",
                text: widget.user.email,
                onChanged: (String value) {
                  email = value.trim();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                label: "New Password",
                suffixIcon: IconButton(
                    onPressed: () {
                      isObscured = !isObscured;
                      setState(() {});
                    },
                    icon: Icon(isObscured ? Icons.visibility: Icons.visibility_off)),
                text: "",
                obscureText: isObscured,
                onChanged: (String value) {
                  password = value.trim();
                },
              ),
              const SizedBox(
                height: 40,
              ),
              isLoading
                  ? const Loader()
                  : ButtonWidget(
                      text: "Update",
                      onClicked: () {
                        email ??= widget.user.email;
                        print(email);
                        print(password);
                        if (password != null) {
                          print("action");
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateEmailPassword(
                                  email!, password!.trim(), context);
                        } else {
                          showSnackBar(context, "Update Fields");
                        }
                      })
            ]));
  }
}
