import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/profile/controller/credential_controller.dart';
import 'package:medical_blog_app/features/profile/page/edit_credential_page.dart';
import 'package:medical_blog_app/features/profile/page/edit_profile_page.dart';
import 'package:medical_blog_app/features/profile/widget/appbar_widget.dart';
import 'package:medical_blog_app/features/profile/widget/profile_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditCredentialPage(user: widget.user),
                ),
              );
            },
            child: const Text(
              "Update credential",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          widget.user.img_url != null ?
          ProfileWidget(
            imagePath: widget.user.img_url ?? "",
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: widget.user),
                ),
              );
            },
          ) : CircleAvatar(
            radius: 50,
            
            backgroundColor: Colors.transparent,
            child: TextButton(
              child: Text(
                widget.user.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: widget.user),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          buildName(widget.user),
          const SizedBox(height: 24),
          if (widget.user.isVerified) buildVerificationBadge(),
          const SizedBox(height: 16),
          if (widget.user.currentPosition != null)
            buildCurrentPosition(widget.user),
          const SizedBox(height: 48),
          buildAbout(widget.user),
          if (widget.user.expertise != null && widget.user.expertise!.isNotEmpty) buildExpertise(widget.user),

          if(widget.user.credentials != null && widget.user.credentials!.isNotEmpty ) Credentials(userId: widget.user.id),
          //if (widget.user.credentials.isNotEmpty)
          // buildCredentials(widget.user),
          if (widget.user.socialLinks != null && widget.user.socialLinks!.isNotEmpty) buildSocialLinks(widget.user),
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              if (user.title != null)
                Text(
                  ' (${user.title})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          ),
          if (user.specialization != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                user.specialization!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      );

  Widget buildVerificationBadge() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 48),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Verified Medical Professional',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget buildCurrentPosition(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Position',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user.currentPosition!,
              style: const TextStyle(fontSize: 16),
            ),
            if (user.institution != null)
              Text(
                user.institution!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      );

  Widget buildAbout(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about ??
                  "Talk about yourself, your interests ...".capitalize(),
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildExpertise(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Areas of Expertise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.expertise == null ? [] : user.expertise!.map((expertise) {
                return Chip(
                  label: Text(expertise),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget buildCredentials(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credentials',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...user.credentials == null ? [] : user.credentials!.map((credential) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                    title: Text(credential.title),
                    subtitle: Text(
                      '${credential.institution} (${credential.year})',
                    ),
                    trailing: credential.isVerified
                        ? const Icon(Icons.verified, color: Colors.green)
                        : null),
              );
            }).toList(),
          ],
        ),
      );

  Widget buildSocialLinks(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: user.socialLinks == null ? [] : user.socialLinks!.entries.map((entry) {
                return IconButton(
                  icon: _getSocialIcon(entry.key),
                  onPressed: () {
                    // TODO: Open social link
                    _openSocialLink(entry.value);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );

  _openSocialLink(String link) async {
    try {
      final Uri url = Uri.parse(link);
      await launchUrl(url);
    } catch (e) {
      showSnackBar(context, 'Could not launch $link');
      throw Exception('Could not launch $link');
    }
  }

  Icon _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
        return const Icon(Icons.flutter_dash);
      case 'linkedin':
        return const Icon(Icons.link);
      case 'facebook':
        return const Icon(Icons.facebook);
      case 'instagram':
        return const Icon(BoxIcons.bxl_instagram);
      default:
        return const Icon(Icons.link);
    }
  }
}

class Credentials extends ConsumerWidget {
  final String userId;
  Credentials({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCredentialsProvider.call(userId)).when(
      data: (data) {
        print("data: $data");
        print("firing");

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Credentials',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (data.isEmpty) Container(),
              ...data.map((credential) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                      title: Text(credential.title),
                      subtitle: Text(
                        '${credential.institution} (${credential.year})',
                      ),
                      trailing:
                          const Icon(Icons.verified, color: Colors.green)),
                );
              }).toList(),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
            child: Text("Error getiing credentials: ${error.toString()}"));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
