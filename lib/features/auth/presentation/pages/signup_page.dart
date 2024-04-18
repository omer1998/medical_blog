import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';

import '../bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(
      builder: (context) => SignupPage(),
    );
  }

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }
          if (state is AuthSuccess) {
            Navigator.push(context, LoginPage.route());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Sign Up.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(controller: nameController, hintText: "Name"),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(controller: emailController, hintText: "Email"),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AuthBtn(
                      btnText: "Sign Up",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(SignUpEvent(
                              SignUpData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text)));
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, LoginPage.route()),
                    child: RichText(
                        text: TextSpan(
                            text: "Already have an account ?",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                          TextSpan(
                              text: " Log In",
                              style: TextStyle(color: AppPallete.gradient2))
                        ])),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
