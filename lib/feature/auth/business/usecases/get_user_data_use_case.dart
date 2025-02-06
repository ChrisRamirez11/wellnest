// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:wellnest/feature/auth/business/entities/profile_entity.dart';
import 'package:wellnest/feature/auth/business/repositories/profile_repository.dart';

import '../../../../../core/errors/failures.dart';

class GetUserDataUseCase {
  ProfileRepository profileRepository;

  GetUserDataUseCase({
    required this.profileRepository,
  });

  Future<Either<Failure, ProfileEntity>> call() async {
    return await profileRepository.getUserData();
  }
}
