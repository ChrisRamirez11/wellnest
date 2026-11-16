import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';

import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getMyUserData();
  Future<Either<Failure, ProfileModel>> getUserDataById(String userId);
  Future<Either<Failure, void>> updateMyUserData(ProfileModel profile);
  Future<Either<Failure, void>> signOut();
}
