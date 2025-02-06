import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';

import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure,ProfileModel>> getUserData();
  Future<Either<Failure,void>> updateProfile(String name);
  Future<Either<Failure,void>> signOut();
}