import 'dart:async';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/consts/consts.dart';

import '../../../../main.dart';

Future<void> googleNativeSignIn() async {
  const webClientId = Consts.webClient;

  const iosClientId = Consts.iosClient;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser?.authentication;
  final accessToken = googleAuth?.accessToken;
  final idToken = googleAuth?.idToken;

  if (accessToken == null) {
    log('No Access Token found.');
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }
  try {
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  } catch (e) {
    throw 'Error inesperado $e';
  }
}

