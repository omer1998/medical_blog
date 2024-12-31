import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/features/profile/data/models/credential_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final credentialRepositoryProvider = Provider((ref) => CredentialRepository());

class CredentialRepository {
  final supabase = Supabase.instance.client;

  // Add a new credential
  Future<CredentialModel> addCredential(CredentialModel credential) async {
    final response = await supabase
        .from('credentials')
        .insert(credential.toJson())
        .select()
        .single();
    
    return CredentialModel.fromJson(response);
  }

  // Update a credential
  Future<CredentialModel> updateCredential(CredentialModel credential) async {
    final response = await supabase
        .from('credentials')
        .update(credential.toJson())
        .eq('id', credential.id)
        .select()
        .single();
    
    return CredentialModel.fromJson(response);
  }

  // Delete a credential
  Future<void> deleteCredential(String credentialId) async {
    await supabase
        .from('credentials')
        .delete()
        .eq('id', credentialId);
  }

  // Get all credentials for a user
  Future<List<CredentialModel>> getUserCredentials(String userId) async {
    final response = await supabase
        .from('credentials')
        .select()
        .eq('user_id', userId);
    
    return (response as List)
        .map((credential) => CredentialModel.fromJson(credential))
        .toList();
  }

  // Submit credential for verification
  Future<CredentialModel> submitForVerification(
    String credentialId,
    String documentUrl,
  ) async {
    final response = await supabase
        .from('credentials')
        .update({
          'documentUrl': documentUrl,
          'status': VerificationStatus.pending.toString().split('.').last,
        })
        .eq('id', credentialId)
        .select()
        .single();
    
    return CredentialModel.fromJson(response);
  }

  // Verify a credential (admin only)
  Future<CredentialModel> verifyCredential(
    String credentialId,
    String adminId,
    bool isApproved,
  ) async {
    final status = isApproved ? VerificationStatus.verified : VerificationStatus.rejected;
    
    final response = await supabase
        .from('credentials')
        .update({
          'status': status.toString().split('.').last,
          'verifiedAt': DateTime.now().toIso8601String(),
          'verifiedBy': adminId,
        })
        .eq('id', credentialId)
        .select()
        .single();
    
    return CredentialModel.fromJson(response);
  }
}
