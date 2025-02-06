// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:wellnest/auth/business/repositories/profile_repository.dart';

import '../../../../core/errors/failures.dart';

class UpdateProfileUseCase {
  ProfileRepository profileRepository;

  UpdateProfileUseCase({
    required this.profileRepository,
  });

  Future<Either<Failure, void>> call(String name) async {
    return await profileRepository.updateProfile(name);
  }
}
