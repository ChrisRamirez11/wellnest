// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/auth/business/usecases/get_user_data_use_case.dart';
import 'package:wellnest/feature/auth/business/usecases/sign_out_use_case.dart';
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

  void setToNull() {
    profile = null;
    failure = null;
    notifyListeners();
  }

  Future<void> getUserData() async {
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

  Future<void> signOut(BuildContext context) async {
    final signedOutOrFailure =
        await SignOutUseCase(profileRepository: _profileRepositoryImpl).call();

    signedOutOrFailure.fold(
      (newFailure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(newFailure.errorMessage)));
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
