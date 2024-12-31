import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';

import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';

class ProfileDrawer extends StatelessWidget {
  final UserEntity user;
  const ProfileDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AuthLogOutSuccess){
          GoRouter.of(context).goNamed("login");
        }else if (state is! UserLoggedInState ){
           GoRouter.of(context).goNamed("login");
        }
      },
      builder: (context, state) {
        if (state is UserLoggedInState) {
          print("user drawer");
          print(state.user.toString());
          final user = state.user;
          return Drawer(
          child:Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    
                     SizedBox(
                      height: 200
                      ,
                       child: DrawerHeader(
                          decoration: BoxDecoration(
                            
                          ),
                          child: Column(
                            children: [
                              // CircleAvatar(
                              //   radius: 50,
                              //   backgroundImage: user.img_url == null ? null : NetworkImage(user.img_url!),
                              //   child: user.img_url == null ? Text(user.name[0].capitalize() ?? "", style: TextStyle(fontSize: 22,color: AppPallete.gradient1),) : null
                              // ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),

                                child: CachedNetworkImage(
                                  imageUrl:user.img_url != null ? "${user.img_url}" : "",
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Image.asset("./assets/images/profile_images/doctor_logo_3.jpg", width: 50, height: 50, fit: BoxFit.cover,);
                                  },
                                  placeholder: (context, url){
                                    return Image.asset("./assets/images/profile_images/doctor_logo_3.jpg", width: 50, height: 50, fit: BoxFit.cover,);
                                    
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(user.name.capitalize(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              Text(user.email, style: TextStyle(fontSize: 15),),
                            ],
                          ),
                        ),
                     ),
                    // ListTile(
                    //   leading: Icon(Icons.person
                    //     )
                    //     UserAccountsDrawerHeader(
                    //       margin: EdgeInsets.all(0),
                    //       accountName: Text(user.name.capitalize()),
                    //       decoration: BoxDecoration(
                    //         color: Colors.transparent,
                    //       ),
                    //       // BlocBuilder<AppUserCubit, AppUserState>(
                    //       //   builder: (context, state) {
                    //       //     if (state is UserLoggedInState) {
                    //       //       print("user name is");
                    //       //       print(state.user.id);
                    //       //       return Text(
                    //       //         " ${state.user.name.capitalize()}",
                    //       //         style: TextStyle(fontSize: 8),
                    //       //       );
                    //       //     } else {
                    //       //       return Text("User");
                    //       //     }
                    //       //   },
                    //       // ),
                    //       accountEmail: Text(user.email ?? ""),
                    //       currentAccountPictureSize: Size.square(50),
                    //       currentAccountPicture: CircleAvatar(
                    //         radius: 10,
                    //         backgroundImage: NetworkImage(user.img_url!),
                    //         // backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    //         // child: Text(
                    //         //   user.name[0].capitalize() ?? "",
                    //         //   style: TextStyle(fontSize: 22, color: Colors.blue),
                    //         // ), //Text
                    //       ),
                    //     )),
                    ListTile(
                      title: const Text("Profile"),
                      leading: const Icon(Icons.person_2),
                      onTap: () {
                        GoRouter.of(context).pushNamed("profile",
                            extra:user);
                      },
                    ),
                    // ListTile(
                    //   title: const Text("My Cases"),
                    //   leading: const Icon(Icons.person_2),
                    //   onTap: () {
                        
                    //   },
                    // ),
                    
                    
                  ],
                ),
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
                      // maximumSize: Size(double.infinity, 50),
                      minimumSize: Size(double.infinity, 50),
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
          return Container();
        }
      },
    );
  }
}
