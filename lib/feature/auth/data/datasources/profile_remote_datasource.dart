import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/feature/auth/data/models/profile_model.dart';
import 'package:wellnest/core/errors/excpetions.dart';

import '../../../../../main.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getMyUserData();
  Future<ProfileModel> getUserDataById(String userId);
  Future<void> updateMyUserData(ProfileModel profile);
  Future<void> signOut();
}

class ProfileRemoteDatasourceImpl extends ProfileRemoteDatasource {
  //getProfileData
  @override
  Future<ProfileModel> getMyUserData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final profileMap =
          await supabase.from('profiles').select().eq('id', userId).single();

      final role =
          await supabase.from('roles').select().eq('user_id', userId).single();

      ProfileModel profile = ProfileModel(
          id: profileMap['id'],
          fullName: profileMap['fullname'] ?? '',
          email: profileMap['email'],
          role: role['role'],
          avatarUrl: profileMap['avatar_url'],
          occupation: profileMap['occupation'] ?? '',
          city: profileMap['city'] ?? '',
          description: profileMap['description'] ?? '',
          goals: profileMap['goals'] ?? [],
          interests: profileMap['interests'] ?? [],
          karma: profileMap['karma'] ?? 0,
          latitude: profileMap['latitude'] ?? 0.0,
          longitude: profileMap['longitude'] ?? 0.0);

      return profile;
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      log('get user data $error');
      throw ServerException(message: 'Network Error');
    }
  }

  @override
  Future<ProfileModel> getUserDataById(String userId) async {
    try {
      final profileMap =
          await supabase.from('profiles').select().eq('id', userId).single();

      final role =
          await supabase.from('roles').select().eq('user_id', userId).single();

      return ProfileModel(
          id: profileMap['id'],
          fullName: profileMap['fullname'] ?? '',
          email: profileMap['email'],
          role: role['role'],
          avatarUrl: profileMap['avatar_url'],
          occupation: profileMap['occupation'] ?? '',
          city: profileMap['city'] ?? '',
          description: profileMap['description'] ?? '',
          goals: profileMap['goals'] ?? [],
          interests: profileMap['interests'] ?? [],
          karma: profileMap['karma'] ?? 0,
          latitude: profileMap['latitude'] ?? 0.0,
          longitude: profileMap['longitude'] ?? 0.0);
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      log('get user data by id $error');
      throw ServerException(message: "Couldn't fecth data. Network error");
    }
  }

  @override
  Future<void> updateMyUserData(ProfileModel profile) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('profiles').update({
        'fullname': profile.fullName,
        'avatar_url': profile.avatarUrl,
        'occupation': profile.occupation,
        'city': profile.city,
        'description': profile.description,
        'goals': profile.goals,
        'interests': profile.interests,
        'latitude': profile.latitude,
        'longitude': profile.longitude,
      }).eq('id', userId);
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      log('update user data $error');
      throw ServerException(message: "Couldn't update your data. Network error");
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
      throw ServerException(message: 'Network Error');
    }
  }
}
