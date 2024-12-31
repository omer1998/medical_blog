import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/profile/model/user.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              color: AppPallete.gradient1.withOpacity(0.1),
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.imagePath),
                  ),
                  const SizedBox(height: 16),
                  
                  // Name and Title
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.title != null)
                    Text(
                      '${user.title} ${user.specialization ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  
                  // Verification Badge
                  if (user.isVerified)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Verified Professional',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Current Position
            if (user.currentPosition != null)
              _buildSection(
                title: 'Current Position',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              ),

            // Bio/About
            _buildSection(
              title: 'About',
              content: Text(
                user.about,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Expertise
            if (user.expertise.isNotEmpty)
              _buildSection(
                title: 'Areas of Expertise',
                content: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.expertise.map((expertise) {
                    return Chip(
                      label: Text(expertise),
                      backgroundColor: AppPallete.gradient1.withOpacity(0.1),
                    );
                  }).toList(),
                ),
              ),

            // Credentials
            if (user.credentials.isNotEmpty)
              _buildSection(
                title: 'Credentials',
                content: Column(
                  children: user.credentials.map((credential) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(credential.title),
                        subtitle: Text(
                          '${credential.institution} (${credential.year})',
                        ),
                        trailing: credential.isVerified
                            ? const Icon(Icons.verified, color: Colors.green)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Contact Information
            _buildSection(
              title: 'Contact Information',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactRow(
                    Icons.email,
                    user.email,
                  ),
                  const SizedBox(height: 8),
                  // Social Links
                  if (user.socialLinks.isNotEmpty)
                    Wrap(
                      spacing: 16,
                      children: user.socialLinks.entries.map((entry) {
                        return IconButton(
                          icon: _getSocialIcon(entry.key),
                          onPressed: () {
                            // Open social link
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Icon _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
        return const Icon(Icons.flutter_dash);
      case 'linkedin':
        return const Icon(Icons.link);
      case 'facebook':
        return const Icon(Icons.facebook);
      default:
        return const Icon(Icons.link);
    }
  }
}
