import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/auth/data/models/profile_model.dart';
import 'package:wellnest/core/errors/excpetions.dart';

import '../../../../main.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getUserData();
  Future<void> upsertProfile(String name);
  Future<void> signOut();
}

class ProfileRemoteDatasourceImpl extends ProfileRemoteDatasource {
  //getProfileData
  @override
  Future<ProfileModel> getUserData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final profileMap =
          await supabase.from('profiles').select().eq('id', userId).single();

      final role =
          await supabase.from('roles').select().eq('user_id', userId).single();

      ProfileModel profile = ProfileModel(
          id: profileMap['id'],
          fullName: profileMap['fullName'] ?? '',
          email: profileMap['email'],
          role: role['role']);

      return profile;
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      log('get user data $error');
      throw ServerException(message: 'Ha ocurrido un error de red');
    }
  }

  //updateProfile
  @override
  Future<void> upsertProfile(String name) async {
    final fullName = name;
    final user = supabase.auth.currentUser;
    final updates = {'id': user!.id, 'fullName': fullName, 'email': user.email};

    try {
      await supabase.from('profiles').upsert(updates);
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      log('upsert user $error');
      throw ServerException(message: 'Ha ocurrido un error de red');
    }
  }

  //signOut
  @override
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      log('sign out $error');
      throw ServerException(message: 'Ha ocurrido un error de red');
    }
  }
}
