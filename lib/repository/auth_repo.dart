import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whomeam/config/paths.dart';
import 'package:whomeam/config/tools.dart';
import 'package:whomeam/models/failure_model.dart';
import 'package:whomeam/models/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  //class data
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _messaging;

  //constructor
  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
    FirebaseMessaging? messaging,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();
  auth.User? currUser;

  //                                                           Save a users new token to a the database
  Future<void> saveTokenToDatabase(String token) async {
    String userId = currUser!.uid;
    if (currUser == null) {
      exit(-1);
    }
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'token': [token] //FieldValue.arrayUnion([token])
    });
  }

  //                                                          sign up with email and password
  @override
  Future<auth.User> signUpWithEmailAndPassword(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      final List<String> usernameSearchCase =
          AdvancedQuerry().advancedSearch(query: username);
      // String? token = await _messaging.getToken();
      _firebaseFirestore.collection(Paths.users).doc(user!.uid).set({
        'username': username.toLowerCase(),
        'email': email,
        'usernameSearchCase': usernameSearchCase,
        'token': [],
      });

      currUser = credential.user;
      String? token = await FirebaseMessaging.instance.getToken();
      await saveTokenToDatabase(token!);
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    }
  }

  //-------------------------------------------------------------------------------- login with email and password
  @override
  Future<auth.User> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      currUser = credential.user;
      String? token = await FirebaseMessaging.instance.getToken();
      await saveTokenToDatabase(token!);
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

      return credential.user!;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    }
  }

  // if user was new reset the var userisNew = null. so that if log out and in all in one session the app wont bug out.
  void resetNewIsUserNew() {}

  //log out of app
  @override
  Future<void> logout() async {
    final googleSignIn = GoogleSignIn();
    final signedIn = await googleSignIn.isSignedIn();
    if (signedIn) {
      await googleSignIn.signOut();
      await _firebaseAuth.signOut();
    }
    await _firebaseAuth.signOut();
  }

  // Future<void> deleteAccount() async {
  //   if (currUser != null) {
  //     currUser!.delete();
  //     // remove the users post
  //     FirebaseFirestore db = FirebaseFirestore.instance;
  //     var batch = db.batch();
  //     QuerySnapshot p = await FirebaseFirestore.instance.collection(Paths.posts).where('author', isEqualTo: FirebaseFirestore.instance.collection(Paths.users).doc(currUser!.uid)).get();
  //     p.docs.forEach((doc) async {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       var imageUrl = data['imageUrl'];
  //       var videoUrl = data['videoUrl'];
  //       var thumbnailUrl = data['thumbnailUrl'];
  //       if (imageUrl != null) {
  //         FirebaseStorage.instance.refFromURL(imageUrl).delete();
  //       }
  //       if (videoUrl != null) {
  //         FirebaseStorage.instance.refFromURL(videoUrl).delete();
  //       }
  //       if (thumbnailUrl != null) {
  //         FirebaseStorage.instance.refFromURL(thumbnailUrl).delete();
  //       }
  //       // TODO LATER ADD THE URLS INTO A BATCH DEL;
  //       batch.delete(doc.reference);
  //     });
  //     Userm u = await UserrRepository().getUserrWithId(userrId: currUser!.uid);
  //     if (u.profileImageUrl.isNotEmpty) {
  //       FirebaseStorage.instance.refFromURL(u.profileImageUrl).delete();
  //     }
  //     // ignore: unnecessary_null_comparison
  //     if (u.bannerImageUrl!=null || u.bannerImageUrl.isNotEmpty) {
  //       FirebaseStorage.instance.refFromURL(u.bannerImageUrl).delete();
  //     }
  //     await batch.commit();
  //     // update the user document and make it a deled account
  //     await FirebaseFirestore.instance.collection(Paths.users).doc(currUser!.uid).update(Userm.empty.copyWith().toDoc());
  //   }
  // }

  final googleSignIn = GoogleSignIn();
  // Stream<auth.User?> get user => _firebaseAuth.userChanges();
  // Stream<auth.UserCredential> get googleUser =>
  //     _firebaseAuth.authStateChanges();

  @override
  Future<auth.User?> signInWithGoogle() async {
    auth.User? user;
    //trigger auth flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create a new crediental
    final crediential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(crediential);
      user = userCredential.user;

      final List<String> usernameSearchCase =
          AdvancedQuerry().advancedSearch(query: googleUser.displayName!);

      if (userCredential.additionalUserInfo != null &&
          userCredential.additionalUserInfo!.isNewUser) {
        _firebaseFirestore.collection(Paths.users).doc(user!.uid).set({
          'profileImageUrl': user.photoURL,
          // 'username': "!" + formatUsername(user.displayName, user.uid),
          'username': formatUsername(user.displayName, user.uid).toLowerCase(),
          'usernameSearchCase': usernameSearchCase,
          'email': user.email,
          'followers': 0,
          'following': 0,
          'token': [],
        });
      }

      currUser = userCredential.user;
      String? token = await FirebaseMessaging.instance.getToken();
      await saveTokenToDatabase(token!);
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    }
  }

  // APPLE AUTH
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<auth.User?> signInWithApple(BuildContext context) async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // make the user to be returned.
      final auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      currUser = userCredential.user;

      if (userCredential.additionalUserInfo != null &&
          userCredential.additionalUserInfo!.isNewUser) {
        _firebaseFirestore.collection(Paths.users).doc(currUser!.uid).set({
          'profileImageUrl': currUser!.photoURL ?? "",
          // 'username': "!" + formatUsername(null, currUser!.uid),
          'username': formatUsername(currUser!.displayName, currUser!.uid)
              .toLowerCase(),
          'email': appleCredential.email,
          'followers': 0,
          'following': 0,
          'token': [],
          'colorPref': '#9814F4'
        });
      }

      String? token = await FirebaseMessaging.instance.getToken();
      await saveTokenToDatabase(token!);
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
      return currUser;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    }
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  String formatUsername(String? name, String uid) {
    String newName = "";
    if (name == null) {
      return "user#" + uid.substring(0, 4);
    }
    for (int i = 0; i < name.length; i++) {
      if (name[i] == " ") {
        newName += "_";
      } else {
        newName += name[i];
      }
    }
    return newName;
  }
}
