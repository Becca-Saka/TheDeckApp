import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thedeck/features/authentication/authentication.dart';
import 'package:thedeck/services/location_service.dart';

import '../app/routes/const_routes.dart';
import 'firebase_auth_service.dart';
import 'firebase_firestore_services.dart';

class AuthenticationService {
  AuthenticationService({
    required this.firebaseAuthService,
    required this.firestoreService,
    required this.navigationService,
    required this.appDialog,
  });
  final FacebookAuth facebookInstance = FacebookAuth.instance;
  final FirebaseAuthService firebaseAuthService;
  final FirestoreServices firestoreService;
  final NavigationService navigationService;
  final AppDialog appDialog;

  bool get isProviderFacebook => firebaseAuthService.providerIsFacebook;

  Future<void> signUp(String email, String password, String name, String age,
      String gender, String path) async {
    try {
      await appDialog.showLoadingDialog(msg: 'Signing up,');
      final userId = await firebaseAuthService.signUp(email, password);
      if (userId != null) {
        final url = await _saveProfileImage(path, userId);
        await firestoreService.saveUserData(
            email, name, age, gender, userId, url);
        await navigationService.closeAllAndNavigateTo(AppRoutes.exp);
      }
    } on FirebaseAuthException catch (e) {
      navigationService.close(1);
      log('FirebaseAuthException: $e');
      final errorMessage = getMessageFromErrorCode(e);
      appDialog.errorSnackbar(msg: errorMessage);
    } catch (e) {
      navigationService.close(1);
      log('Exception: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      appDialog.showLoadingDialog(msg: 'Logging in');

      final userId = await firebaseAuthService.signIn(email, password);
      if (userId != null) {
        final user = await firestoreService.getUserData(userId);
        navigationService.close(1);
        if (user != null && user.lat == null && user.long == null) {
          navigationService.closeAllAndNavigateTo(AppRoutes.exp);
        } else {
          navigationService.closeAllAndNavigateTo(AppRoutes.home);
        }
      }
    } on FirebaseAuthException catch (e) {
      navigationService.close(1);
      log('FirebaseAuthException: $e');

      final errorMessage = getMessageFromErrorCode(e);
      appDialog.errorSnackbar(msg: errorMessage);
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await facebookInstance.login();

      if (result.status == LoginStatus.success) {
        appDialog.showLoadingDialog(msg: 'Logging in,');
        final userData = await facebookInstance.getUserData();
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final credential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);

        final userDetails =
            await firestoreService.getData(credential.user!.uid);
        if (!userDetails.exists) {
          _goToSignUpForData(userData['name'], facebookCredential, credential,
              userData['picture']['data']['url']);
        } else {
          await firestoreService.getUserData(credential.user!.uid);
          navigationService.closeAllAndNavigateTo(AppRoutes.home);
        }
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      log('Error from $e');
    }
  }

  void _goToSignUpForData(String name, dynamic credential, dynamic token,
      [String? url]) {
    locator<AuthenticationController>()
        .setDataFromSocial(name, credential, token, url);

    navigationService.closeAllAndNavigateTo(AppRoutes.signUp);
  }

  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      appDialog.showLoadingDialog(msg: 'Logging in,');

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );
      final credential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final userDetails = await firestoreService.getData(credential.user!.uid);
      if (!userDetails.exists) {
        _goToSignUpForData(
            appleCredential.givenName ?? appleCredential.familyName ?? '',
            oauthCredential,
            credential);
      } else {
        appDialog.showLoadingDialog();
        await firestoreService.getUserData(credential.user!.uid);
        navigationService.closeAllAndNavigateTo(AppRoutes.home);
      }
    } on UnknownSignInWithAppleException {
      appDialog.errorSnackbar(msg: 'Something went wrong, Please try again');
    } on SignInWithAppleNotSupportedException {
      appDialog.errorSnackbar(
          msg:
              'Apple Sign In is not supported on this device\n Please try other authentication methods');
    }
  }

  Future<void> validateSignInWithApple(
    String age,
    String gender,
    String path,
    String name,
    dynamic credientials,
    dynamic token, {
    bool imageFromProvider = false,
  }) async {
    appDialog.showLoadingDialog(msg: '');
    if (imageFromProvider == false) {
      path = await _saveProfileImage(path, 'user.uid');
    }
    final userDetails = await firestoreService.getData(token.user!.uid);
    if (!userDetails.exists) {
      await firestoreService.saveUserData(
          token.user!.email!, name, age, gender, token.user!.uid, path);

      navigationService.closeAllAndNavigateTo(AppRoutes.exp);
    } else {
      await firestoreService.getUserData(userDetails.id);
      navigationService.closeAllAndNavigateTo(AppRoutes.home);
    }
  }

  Future<UserDetails?> checkLogin() async {
    try {
      User? user = firebaseAuthService.currentUser;
      if (user != null) {
        IdTokenResult tokenResult = await user.getIdTokenResult(true);
        if (tokenResult.token != null) {
          return await firestoreService.getUserData(user.uid);
        }
      }
    } catch (e) {
      log('Error: $e');
    }
    return null;
  }

  Future<void> forgotPassword(String email) async {
    try {
      appDialog.showLoadingDialog(msg: 'Sending Passord reset link');

      await firebaseAuthService.sendPasswordResetEmail(email: email);
      navigationService.close(1);
      appDialog.successSnackbar(
          msg: 'Check your email for reset password link',
          title: 'Password Reset Email sent');
    } on FirebaseAuthException catch (e) {
      navigationService.close(1);
      log('FirebaseAuthException: $e');
      final errorMessage = getMessageFromErrorCode(e);
      appDialog.errorSnackbar(msg: errorMessage);
    } catch (e) {
      navigationService.close(1);
      log('Error: $e');
    }
  }

  Future<String> _saveProfileImage(String path, String id) async {
    storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref('Users/$id')
        .child('${Timestamp.now().microsecondsSinceEpoch}');

    final storage.UploadTask uploadTask = storageReference.putFile(File(path));
    final storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future<void> updateUserLocation() async {
    final uid = firebaseAuthService.currentUser!.uid;
    try {
      LocationService locationService = locator<LocationService>();
      final pos = await locationService.determinePosition();
      await firestoreService.update(id: uid, data: {
        'lat': pos.latitude,
        'long': pos.longitude,
      });
      await firestoreService.getUserData(uid);
      navigationService.closeAllAndNavigateTo(AppRoutes.home);
    } catch (e) {
      appDialog.errorSnackbar(msg: '$e');
    }
  }

  Stream<UserDetails> getUserStream() {
    return firestoreService.getUserStream(firebaseAuthService.currentUser!.uid);
  }

  Future<void> deleteImageFromStorage(String url) async {
    if (url.toLowerCase().contains('firebasestorage.googleapis.com')) {
      storage.Reference storageReference =
          storage.FirebaseStorage.instance.refFromURL(url);
      await storageReference.delete();
    }
  }

  Future<void> updateUserData(
    UserDetails userDetails, {
    bool imageUpdated = false,
    bool profileImageUpdated = false,
    int? index,
    required List<ImageDetails> imagesMaped,
  }) async {
    if (imageUpdated) {
      final imagelist = userDetails.imageList;
      for (final image in imagesMaped) {
        if (image.isImageUpdated) {
          if (image.isImageRemoved && !image.onLocal) {
            await deleteImageFromStorage(image.firebaseUrl!);
            imagelist.removeWhere((element) => element == image.firebaseUrl);
          }
          if (image.onLocal) {
            final url = await _saveProfileImage(
              image.localUrl!,
              userDetails.uid!,
            );
            if (userDetails.imageList.asMap().containsKey(image.index)) {
              await deleteImageFromStorage(image.firebaseUrl!);
              userDetails.imageList[image.index] = url;
            } else {
              userDetails.imageList.add(url);
            }
          }
        }
      }
      userDetails.imageList = imagelist;
    }
    if (profileImageUpdated) {
      userDetails.imageUrl = userDetails.imageList[index!];
    }
    userDetails.lastMatchedTime = userDetails.lastMatchedTime;
    return await firestoreService.update(
        id: userDetails.uid!, data: userDetails.toJson());
  }

  Future<void> updateUserDataOther(UserDetails userDetails) async {
    await firestoreService.update(
        id: userDetails.uid!, data: userDetails.toJson());
  }

  Future<void> logout(uid) async {
    try {
      appDialog.showLoadingDialog(msg: 'Logging out,');
      if (isProviderFacebook) {
        await facebookInstance.logOut();
      }
      await firestoreService.update(id: uid, data: {'fcmToken': null});
      await firebaseAuthService.signOut().whenComplete(() {
        navigationService.closeAllAndNavigateTo(AppRoutes.login);
        resetLocator();
      });
    } on FirebaseAuthException catch (e) {
      navigationService.close(1);
      log('FirebaseAuthException: $e');
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  Future<void> deleteAccount(UserDetails currentUser,
      {String? password}) async {
    try {
      appDialog.showLoadingDialog(msg: 'Logging in,');
      AuthCredential? credential;
      if (!isProviderFacebook) {
        credential = EmailAuthProvider.credential(
            email: currentUser.email!, password: password!);
      } else {
        final accessToken = await FacebookAuth.instance.accessToken;
        credential = FacebookAuthProvider.credential(accessToken!.token);
      }

      await firebaseAuthService.reauthenticateWithCredential(credential);
      final uid = currentUser.uid;
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('recursiveDeleteUser');
      callable.call({
        'path': uid,
        'currentMatches': currentUser.currentMatches,
        'currentDeck': currentUser.currentDeck,
      });
      await firebaseAuthService.delete().whenComplete(() {
        navigationService.closeAllAndNavigateTo(AppRoutes.login);
        resetLocator();
      });
    } on FirebaseAuthException catch (e) {
      navigationService.close(1);
      log('FirebaseAuthException: $e');
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        const msg = 'Wrong password provided for that user.';
        log(msg);
        appDialog.errorSnackbar(msg: msg);
      }
    }
  }
}

String getMessageFromErrorCode(FirebaseAuthException e) {
  String msg;
  switch (e.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      msg = "Email already used. Go to login page.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      msg = "Wrong email/password combination.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      msg = "No user found with this email.";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      msg = "User disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      msg = "Too many requests to log into this account.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      msg = "Server error, please try again later.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      msg = "Email address is invalid.";
      break;
    default:
      msg = "Login failed. Please try again.";
      break;
  }
  return msg;
}
