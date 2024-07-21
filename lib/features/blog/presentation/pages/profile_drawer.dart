import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(
              child: Column(
                children: [
            CircleAvatar(
              child: Icon(
                Icons.person,
                size: 50,
              ),
              radius: 50,
            ),
            SizedBox(height: 10,),
            BlocBuilder<AppUserCubit, AppUserState>(builder:(context, state) {
             if (state is UserLoggedInState){
              print("user name is");
              print(state.user.id);
              return Text(" ${state.user.name.capitalize()}",style: TextStyle(fontSize: 16),);
             }else {
               return Text("User");
             }
           },),
           
          ])),
          // SizedBox(
          //   height: 30,
          // ),
          

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthLoading) {
                return Loader();
              }
              return TextButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.error))
                                ),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context, listen: false)
                      .add(LogOutEvent(noParams: NoParams(), context: context));
                },
                label: Text(
                  "Log Out",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
