import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';

import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is UserLoggedInState) {
          print("user drawer");
          print(state.user.toString());
          final user = state.user;
          return Drawer(
          child: ListView(
            children: [
              
               DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: UserAccountsDrawerHeader(
                    accountName: Text(user.name.capitalize()),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    // BlocBuilder<AppUserCubit, AppUserState>(
                    //   builder: (context, state) {
                    //     if (state is UserLoggedInState) {
                    //       print("user name is");
                    //       print(state.user.id);
                    //       return Text(
                    //         " ${state.user.name.capitalize()}",
                    //         style: TextStyle(fontSize: 8),
                    //       );
                    //     } else {
                    //       return Text("User");
                    //     }
                    //   },
                    // ),
                    accountEmail: Text(user.email ?? ""),
                    currentAccountPictureSize: Size.square(40),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 165, 255, 137),
                      child: Text(
                        user.name[0].capitalize() ?? "",
                        style: TextStyle(fontSize: 22, color: Colors.blue),
                      ), //Text
                    ),
                  )),
              ListTile(
                title: const Text("Profile"),
                leading: const Icon(Icons.person_2),
                onTap: () {
                  GoRouter.of(context).pushNamed("profile",
                      extra:user);
                },
              ),ListTile(
                title: const Text("My Cases"),
                leading: const Icon(Icons.person_2),
                onTap: () {
                  GoRouter.of(context).pushNamed("profile",
                      extra: UserModel(
                          name: "omer faris",
                          email: "omerfaris11@gmail.com",
                          id: "ocodmocdjn dfkk jvdn"));
                },
              ),ListTile(
                title: const Text("Profile"),
                leading: const Icon(Icons.person_2),
                onTap: () {
                  GoRouter.of(context).pushNamed("profile",
                      extra: UserModel(
                          name: "omer faris",
                          email: "omerfaris11@gmail.com",
                          id: "ocodmocdjn dfkk jvdn"));
                },
              ),ListTile(
                title: const Text("Profile"),
                leading: const Icon(Icons.person_2),
                onTap: () {
                  GoRouter.of(context).pushNamed("profile",
                      extra: UserModel(
                          name: "omer faris",
                          email: "omerfaris11@gmail.com",
                          id: "ocodmocdjn dfkk jvdn"));
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  if (state is AuthLoading) {
                    return Loader();
                  }
                  return TextButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).colorScheme.error))),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context, listen: false).add(
                          LogOutEvent(noParams: NoParams(), context: context));
                    },
                    label: Text(
                      "Log Out",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                }),
              ),
            
            ],
          )
        );
        }else {
          return Loader();
        }
      },
    );
  }
}
