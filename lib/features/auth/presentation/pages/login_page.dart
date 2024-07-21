import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_page.dart';

class LoginPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            print("login user");
            print(state.user.name);
            BlocProvider.of<AppUserCubit>(context).updateUser(state.user);
            GoRouter.of(context).goNamed("main");
          }
          // else if (state is AuthSuccess) {
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //     builder: (context) {
          //       return BlogPage();
          //     },
          //   ), (_) => false);
          // }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loader();
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
                      "Sign In.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      // textAlign: TextAlign.center,
                    ),
                  ),
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
                      btnText: "Log In",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(SignInEvent(
                              data: SignInData(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim())));
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, SignupPage.route());
                    },
                    child: RichText(
                        text: TextSpan(
                            text: "Don\'t Have an account?",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                          TextSpan(
                              text: " Sign Up",
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
