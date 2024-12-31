import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/features/profile/controller/credential_controller.dart';
import 'package:medical_blog_app/features/profile/data/models/credential_model.dart';

class CredentialsSection extends ConsumerWidget {
  final String userId;

  const CredentialsSection({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentialsAsyncValue = ref.watch(userCredentialsProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Professional Credentials',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddCredentialDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        credentialsAsyncValue.when(
          data: (credentials) => _buildCredentialsList(credentials, ref, context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(
            child: Text('Failed to load credentials'),
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialsList(
    List<CredentialModel> credentials,
    WidgetRef ref,
    BuildContext context,
  ) {
    if (credentials.isEmpty) {
      return const Center(
        child: Text('No credentials added yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: credentials.length,
      itemBuilder: (context, index) {
        final credential = credentials[index];
        return Card(
          child: ListTile(
            title: Text(credential.title),
            subtitle: Text(
              '${credential.institution} (${credential.year})',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVerificationStatus(credential),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditCredentialDialog(
                    context,
                    ref,
                    credential,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(
                    context,
                    ref,
                    credential.id,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerificationStatus(CredentialModel credential) {
    IconData icon;
    Color color;
    String tooltip;

    switch (credential.status) {
      case VerificationStatus.verified:
        icon = Icons.verified;
        color = Colors.green;
        tooltip = 'Verified';
        break;
      case VerificationStatus.rejected:
        icon = Icons.cancel;
        color = Colors.red;
        tooltip = 'Rejected';
        break;
      case VerificationStatus.pending:
        icon = Icons.pending;
        color = Colors.orange;
        tooltip = 'Pending Verification';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(icon, color: color),
    );
  }

  void _showAddCredentialDialog(BuildContext context, WidgetRef ref) {
    String title = '';
    String institution = '';
    String year = '';
    String type = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Credential'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Institution'),
              onChanged: (value) => institution = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Year'),
              onChanged: (value) => year = value,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Type (degree/certification/license)',
              ),
              onChanged: (value) => type = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty &&
                  institution.isNotEmpty &&
                  year.isNotEmpty &&
                  type.isNotEmpty) {
                ref.read(credentialControllerProvider.notifier).addCredential(
                      userId: userId,
                      title: title,
                      institution: institution,
                      year: year,
                      type: type,
                      context: context,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCredentialDialog(
    BuildContext context,
    WidgetRef ref,
    CredentialModel credential,
  ) {
    String title = credential.title;
    String institution = credential.institution;
    String year = credential.year;
    String type = credential.type;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Credential'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: TextEditingController(text: title),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Institution'),
              controller: TextEditingController(text: institution),
              onChanged: (value) => institution = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Year'),
              controller: TextEditingController(text: year),
              onChanged: (value) => year = value,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Type (degree/certification/license)',
              ),
              controller: TextEditingController(text: type),
              onChanged: (value) => type = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty &&
                  institution.isNotEmpty &&
                  year.isNotEmpty &&
                  type.isNotEmpty) {
                ref.read(credentialControllerProvider.notifier).updateCredential(
                      credential: credential.copyWith(
                        title: title,
                        institution: institution,
                        year: year,
                        type: type,
                      ),
                      context: context,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
          if (credential.status != VerificationStatus.verified)
            TextButton(
              onPressed: () {
                ref
                    .read(credentialControllerProvider.notifier)
                    .submitForVerification(
                      credentialId: credential.id,
                      context: context,
                    );
                Navigator.pop(context);
              },
              child: const Text('Submit for Verification'),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String credentialId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Credential'),
        content: const Text('Are you sure you want to delete this credential?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(credentialControllerProvider.notifier).deleteCredential(
                    credentialId: credentialId,
                    context: context,
                  );
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
