import 'package:dartz/dartz.dart';
import 'package:wellnest/auth/business/repositories/profile_repository.dart';

import '../../../../core/errors/failures.dart';

class SignOutUseCase {
  ProfileRepository profileRepository;

  SignOutUseCase({
    required this.profileRepository,
  });

  Future<Either<Failure, void>> call() async {
    return await profileRepository.signOut();
  }
}
