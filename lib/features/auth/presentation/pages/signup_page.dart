import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/profile_completion_page.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:medical_blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpUser() {
    if (!formKey.currentState!.validate()) return;
    
    context.read<AuthBloc>().add(
          SignUpEvent(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            name: nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text(
          'Sign Up',
          style: TextStyle(color: AppPallete.whiteColor),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to profile completion page
            GoRouter.of(context).goNamed('profile_completion');
          }
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step indicator
                  Text(
                    'Step 1 of 2',
                    style: TextStyle(
                      color: AppPallete.gradient1,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form fields
                  AuthField(
                    controller: nameController,
                    hintText: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: emailController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value){
                       if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;

                    } 
                  ),
                  const SizedBox(height: 24),
                  AuthBtn(
                    btnText: 'Continue',
                    onPressed: signUpUser,
                    // onPressed: () {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileCompletionPage()));
                    // },
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        LoginPage.route(),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppPallete.gradient1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
