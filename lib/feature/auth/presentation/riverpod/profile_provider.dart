// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/auth/business/usecases/get_user_data_by_id_usecase.dart';
import 'package:wellnest/feature/auth/business/usecases/get_user_data_use_case.dart';
import 'package:wellnest/feature/auth/business/usecases/sign_out_use_case.dart';
import 'package:wellnest/feature/auth/business/usecases/update_user_data_usecase.dart';
import 'package:wellnest/feature/auth/data/datasources/profile_local_datasource.dart';
import 'package:wellnest/feature/auth/data/datasources/profile_remote_datasource.dart';
import 'package:wellnest/feature/auth/data/models/profile_model.dart';
import 'package:wellnest/feature/auth/data/repositories/profile_repository_impl.dart';
import 'package:wellnest/core/errors/failures.dart';

final profileProvider = ChangeNotifierProvider<ProfileProvider>(
  (ref) => ProfileProvider(),
);

class ProfileProvider extends ChangeNotifier {
  ProfileModel? profile;
  Failure? failure;

  final ProfileRepositoryImpl _profileRepositoryImpl = ProfileRepositoryImpl(
      profileRemoteDatasource: ProfileRemoteDatasourceImpl(),
      profileLocalDatasource: ProfileLocalDatasourceImpl());

  Future<void> getMyUserData() async {
    final profileOrFailure =
        await GetUserDataUseCase(profileRepository: _profileRepositoryImpl)
            .call();

    profileOrFailure.fold(
      (newFailure) {
        profile = null;
        failure = newFailure;
        notifyListeners();
      },
      (user) {
        failure = null;
        profile = ProfileModel.fromEntity(user);
        notifyListeners();
      },
    );
  }

  Future<ProfileModel> getUserDataById(BuildContext context, String id) async {
    final userDataOrFailure =
        await GetUserDataByIdUsecase(profileRepository: _profileRepositoryImpl)
            .call(id);

    return userDataOrFailure.fold(
      (newFailure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            newFailure.errorMessage,
            style: textTheme(context).labelMedium,
          )));
        }
        return ProfileModel(
            id: id,
            fullName: '',
            email: '',
            role: '',
            avatarUrl: '',
            occupation: '',
            city: '',
            description: '',
            goals: [],
            interests: [],
            karma: 0,
            latitude: 0.0,
            longitude: 0.0);
      },
      (profileEntity) => ProfileModel.fromEntity(profileEntity),
    );
  }

  Future<void> updateUserData(
      BuildContext context, ProfileModel profile) async {
    final userUpdatedOrFailure =
        await UpdateUserDataUsecase(profileRepository: _profileRepositoryImpl)
            .call(profile);

    userUpdatedOrFailure.fold(
      (newFailure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            newFailure.errorMessage,
            style: textTheme(context).labelMedium,
          )));
        }
      },
      (success) {
        debugPrint('Update Succesful');
      },
    );
  }

  Future<void> signOut(BuildContext context) async {
    final signedOutOrFailure =
        await SignOutUseCase(profileRepository: _profileRepositoryImpl).call();

    signedOutOrFailure.fold(
      (newFailure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            newFailure.errorMessage,
            style: textTheme(context).labelMedium,
          )));
        }
        notifyListeners();
        return;
      },
      (signedOut) async {
        profile = null;
        failure = null;
        notifyListeners();
      },
    );
  }
}
