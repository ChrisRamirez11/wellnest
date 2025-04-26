import 'package:dartz/dartz.dart';
import 'package:wellnest/feature/auth/business/repositories/profile_repository.dart';
import 'package:wellnest/feature/auth/data/models/profile_model.dart';

import '../../../../../core/errors/failures.dart';

class UpdateUserDataUsecase {
  ProfileRepository profileRepository;

  UpdateUserDataUsecase({
    required this.profileRepository,
  });

  Future<Either<Failure, void>> call(ProfileModel profile) async {
    return await profileRepository.updateMyUserData(profile);
  }
}
