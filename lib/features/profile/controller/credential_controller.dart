import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/profile/data/models/credential_model.dart';
import 'package:medical_blog_app/features/profile/repository/credential_repository.dart';
import 'package:uuid/uuid.dart';

final credentialControllerProvider =
    StateNotifierProvider<CredentialController, bool>((ref) {
  return CredentialController(
    credentialRepository: ref.watch(credentialRepositoryProvider),
  );
});

final userCredentialsProvider = StreamProvider.family((ref, String userId) {
  final credentialController = ref.watch(credentialControllerProvider.notifier);
  return credentialController.watchUserCredentials(userId);
});

class CredentialController extends StateNotifier<bool> {
  final CredentialRepository _credentialRepository;
  final _uuid = const Uuid();

  CredentialController({
    required CredentialRepository credentialRepository,
  })  : _credentialRepository = credentialRepository,
        super(false);

  // Add a new credential
  Future<void> addCredential({
    required String userId,
    required String title,
    required String institution,
    required String year,
    required String type,
    required BuildContext context,
  }) async {
    state = true;
    try {
      final credential = CredentialModel(
        userId: userId,
        id: _uuid.v4(),
        title: title,
        institution: institution,
        year: year,
        type: type,
      );

      await _credentialRepository.addCredential(credential);
      showSnackBar(context, 'Credential added successfully');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    state = false;
  }

  // Update an existing credential
  Future<void> updateCredential({
    required CredentialModel credential,
    required BuildContext context,
  }) async {
    state = true;
    try {
      await _credentialRepository.updateCredential(credential);
      showSnackBar(context, 'Credential updated successfully');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    state = false;
  }

  // Delete a credential
  Future<void> deleteCredential({
    required String credentialId,
    required BuildContext context,
  }) async {
    state = true;
    try {
      await _credentialRepository.deleteCredential(credentialId);
      showSnackBar(context, 'Credential deleted successfully');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    state = false;
  }

  // Submit a credential for verification
  Future<void> submitForVerification({
    required String credentialId,
    required BuildContext context,
  }) async {
    state = true;
    try {
      // Pick a document file
      /* final file = await pickFile();
      if (file != null) {
        // TODO: Upload file to storage and get URL
        final documentUrl = 'storage_url_here';
        
        await _credentialRepository.submitForVerification(
          credentialId,
          documentUrl,
        );
        showSnackBar(context, 'Credential submitted for verification');
      } */
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    state = false;
  }

  // Verify a credential (admin only)
  Future<void> verifyCredential({
    required String credentialId,
    required String adminId,
    required bool isApproved,
    required BuildContext context,
  }) async {
    state = true;
    try {
      await _credentialRepository.verifyCredential(
        credentialId,
        adminId,
        isApproved,
      );
      showSnackBar(
        context,
        isApproved
            ? 'Credential verified successfully'
            : 'Credential verification rejected',
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    state = false;
  }

  // Watch user credentials (real-time updates)
  Stream<List<CredentialModel>> watchUserCredentials(String userId) async* {
    try {
      while (true) {
        final credentials = await _credentialRepository.getUserCredentials(userId);
        yield credentials;
        await Future.delayed(const Duration(seconds: 5)); // Poll every 5 seconds
      }
    } catch (e) {
      yield [];
    }
  }
}
