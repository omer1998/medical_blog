

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/profile/page/edit_credential_page.dart';
import 'package:medical_blog_app/features/profile/page/edit_profile_page.dart';
import 'package:medical_blog_app/features/profile/widget/appbar_widget.dart';
import 'package:medical_blog_app/features/profile/widget/numbers_widget.dart';
import 'package:medical_blog_app/features/profile/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user ;
  const ProfilePage({Key? key, required this.user}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: buildAppBar(context, [TextButton(onPressed: (){
            // GoRouter.of(context).pushNamed("edit_profile", extra: widget.user);
            Navigator.of(context).push(MaterialPageRoute(builder:(context) {
              return EditCredentialPage(user:widget.user);
            },));
          },child: Text("Update credential", style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))]),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: widget.user.img_url ?? "",
                onClicked: () {
                  print("oooooooooo");
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage(user: widget.user,)),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(widget.user),
              const SizedBox(height: 24),
              // Center(child: buildUpgradeButton()),
              // const SizedBox(height: 24),
              NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(widget.user),
            ],
          ),
        );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          IconButton(onPressed: (){

          }, icon:Icon(Icons.add_box_rounded),color: Colors.green,)
            ],
          )
          ,
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'Upgrade To PRO',
  //       onClicked: () {},
  //     );

  Widget buildAbout(UserModel user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about ?? "Talk about youself, your interests ...".capitalize(),
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
