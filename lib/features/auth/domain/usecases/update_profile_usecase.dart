import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params);
  }
}

class UpdateProfileParams {
  final String name;
  final File imageFile;
  final String? title;
  final String? about;
  final String? specialization;
  final String? institution;
  final List<String>? expertise;
  final Map<String, String>? socialLinks;

  UpdateProfileParams({
    required this.name,
    required this.imageFile,
    this.title,
    this.about,
    this.specialization,
    this.institution,
    this.expertise,
    this.socialLinks,
  });

  Map<String, dynamic> toJson() {
    return {
      
      'title': title,
      'about': about,
      'specialization': specialization,
      'institution': institution,
      'expertise': expertise,
      'social_links': socialLinks,
    };
  }
}
