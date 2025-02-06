

import 'package:wellnest/feature/auth/data/models/profile_model.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/core/shared_preferences/user_preferences.dart';

abstract class ProfileLocalDatasource {
  Future<ProfileModel> getCachedUser();
  Future<void> cacheUser(String user);
}

class ProfileLocalDatasourceImpl extends ProfileLocalDatasource {
  final UserPreferences _prefs = UserPreferences();
  @override
  Future<void> cacheUser(String user) {
    if (user.isNotEmpty) {
      _prefs.cacheUser = user;
      return Future.value();
    } else {
      throw CacheException(message: 'Usuario no proporcionado');
    }
  }

  @override
  Future<ProfileModel> getCachedUser() {
    final String user = _prefs.cacheUser;
    if (user.isNotEmpty) {
      return Future.value(ProfileModel.fromJson(user));
    } else {
      throw CacheException(message: 'Nombre no encontrado en cache');
    }
  }
}
