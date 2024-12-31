import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/core/utils/follow_user.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:medical_blog_app/features/profile/controller/profile_controller.dart';
import 'package:medical_blog_app/features/profile/page/edit_credential_page.dart';
import 'package:medical_blog_app/features/profile/page/edit_profile_page.dart';
import 'package:medical_blog_app/features/profile/widget/appbar_widget.dart';
import 'package:medical_blog_app/features/profile/widget/numbers_widget.dart';
import 'package:medical_blog_app/features/profile/widget/profile_widget.dart';

class ProfilePageViewer extends StatefulWidget {
  final UserModel user;
  final String mainUserId;
  final BlogModel blog;
  const ProfilePageViewer(
      {Key? key,
      required this.user,
      required this.mainUserId,
      required this.blog})
      : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageViewer> {
  Set<String> _selected = {"Cases"};
  @override
  Widget build(BuildContext context) {
    print("image url: ${widget.user.img_url!.isEmpty}");
    return Scaffold(
      appBar: buildAppBar(
        context,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          widget.user.img_url != null && widget.user.img_url!.isNotEmpty
              ? Center(
                child: ClipOval(
                      child: Material(
                          color: Colors.transparent,
                          child: CachedNetworkImage(
                  
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.img_url!,  //"${imagePath}?${DateTime.now().microsecond.toString()}",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                          // Ink.image(
                          //   image: image,
                          //   fit: BoxFit.cover,
                          //   width: 128,
                          //   height: 128,
                          //   child: InkWell(onTap: onClicked),
                          // ),
                          ),
                    ),
              )
              // Container(
              //     width: 200,
              //     height: 200,
              //     clipBehavior: Clip.hardEdge,
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         // image: DecorationImage(
              //         //     image: NetworkImage(
              //         //       widget.user.img_url!,
              //         //     ),
              //         //     fit: BoxFit.scaleDown)
                      
              //             ),
              //             child: CachedNetworkImage(imageUrl: widget.user.img_url!, fit: BoxFit.cover,),)

              // CircleAvatar(
              //     radius: 50,
              //     foregroundImage:
              //         NetworkImage(widget.user.img_url!),
              //   )
              // Container(
              //     width: 100,
              //     height: 100,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       image: DecorationImage(
              //         image: NetworkImage(widget.user.img_url!),
              //         fit: BoxFit.fill
              //       ),
              //     ),
              //   )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      "./assets/images/profile_images/doctor_logo_3.jpg"),
                ),
          const SizedBox(height: 24),
          buildName(widget.user),
          // const SizedBox(height: 24),
          // // Center(child: buildUpgradeButton()),
          // // const SizedBox(height: 24),
          // NumbersWidget(),
          const SizedBox(height: 48),
          widget.user.about != null && widget.user.about!.isNotEmpty
              ? buildAbout(widget.user)
              : Container(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton(
              segments: [
                ButtonSegment(
                    label: Text(
                      "Cases",
                      style: TextStyle(fontSize: 18),
                    ),
                    value: "Cases"),
                ButtonSegment(
                    label: Text("Blogs", style: TextStyle(fontSize: 18)),
                    value: "Blogs")
              ],
              selected: _selected,
              onSelectionChanged: (value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
          ),
          _selected.first == "Cases" ? buildCases() : buildBlogs()
        ],
      ),
    );
  }

  buildCases() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getUserCasesProvider.call(widget.user.id)).when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No Cases Yet",
                      style: TextStyle(fontSize: 18),
                    ),
                  ));
                }
                return Column(
                  children: data
                      .map((e) => ListTile(
                          leading: Icon(Icons.description),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(e.case_name.capitalize())))
                      .toList(),
                );
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () => Loader(),
            );
      },
    );
  }

  buildBlogs() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getUserBlogsProvider.call(widget.user.id)).when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No Blogs Yet", style: TextStyle(fontSize: 18)),
                  ));
                }
                return Column(
                  children: data
                      .map((e) => ListTile(
                          leading: Icon(Icons.description),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(e.title.capitalize())))
                      .toList(),
                );
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () => Loader(),
            );
      },
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
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(FontAwesome.user_plus_solid),
              //   color: Colors.green,
              // )
              widget.mainUserId == widget.blog.authorId
                  ? Container()
                  : Consumer(
                      builder: (_, WidgetRef ref, __) {
                        return FutureBuilder<bool>(
                            future: ref.read(followUtilityProvider).isFollowed(
                                widget.mainUserId, widget.blog.authorId),
                            builder: (context, snapshot) {
                              print("snapshot data");
                              print(snapshot.data);
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Loader();
                              } else if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return IconButton.outlined(
                                    onPressed: () async {
                                      if (snapshot.data == true) {
                                        // mean the user is following this writer
                                        // on press here again it will unfollow
                                        print(
                                            " this user if following the other user");
                                        await ref
                                            .read(followUtilityProvider)
                                            .removeFollow(widget.mainUserId,
                                                widget.blog.authorId);

                                        setState(() {});
                                        return;
                                      }
                                      await ref
                                          .read(followUtilityProvider)
                                          .addFollow(widget.mainUserId,
                                              widget.blog.authorId);

                                      setState(() {});
                                      return;
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Icon(
                                        snapshot.data == true
                                            ? FontAwesome.circle_check_solid
                                            : FontAwesome.user_plus_solid,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    ));
                              } else {
                                print(snapshot.error.toString());
                                return Icon(Icons.error);
                              }
                            });
                      },
                    ),
              widget.mainUserId == widget.blog.authorId
                  ? Container()
                  : IconButton.outlined(
                      onPressed: () {},
                      icon: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          FontAwesome.message,
                          color: Colors.yellow,
                          size: 18,
                        ),
                      ))
            ],
          ),
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
              user.about ??
                  "Talk about youself, your interests ...".capitalize(),
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
