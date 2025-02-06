import 'package:dartz/dartz.dart';

import 'package:wellnest/feature/auth/business/repositories/profile_repository.dart';
import 'package:wellnest/feature/auth/data/datasources/profile_local_datasource.dart';
import 'package:wellnest/feature/auth/data/datasources/profile_remote_datasource.dart';
import 'package:wellnest/feature/auth/data/models/profile_model.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/core/errors/failures.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;
  final ProfileLocalDatasource profileLocalDatasource;

  ProfileRepositoryImpl({
    required this.profileRemoteDatasource,
    required this.profileLocalDatasource,
  });

  @override
  Future<Either<Failure, ProfileModel>> getUserData() async {
    ProfileModel profileModel;
    try {
      profileModel = await profileLocalDatasource.getCachedUser();
      return Right(profileModel);
    } on CacheException {
      try {
        profileModel = await profileRemoteDatasource.getUserData();
        await profileLocalDatasource.cacheUser(profileModel.toJson());
        return Right(profileModel);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(String name) async {
    try {
      await profileRemoteDatasource.upsertProfile(name);
      ProfileModel profileModel = await profileLocalDatasource.getCachedUser();
      profileModel.fullName = name;
      await profileLocalDatasource.cacheUser(profileModel.toJson());
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await profileRemoteDatasource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message));
    }
  }
}
