import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:medical_blog_app/core/secrets/app_secrets.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final supabaseClientProvider = Provider<SupabaseClient>((ref) {
 return  Supabase.instance.client;
});

final supabaseStorageClientProvider = Provider<SupabaseStorageClient>((ref) {
  return Supabase.instance.client.storage;
});



final appUserProvider = StateProvider<UserModel?>((ref) {
  return null;
});