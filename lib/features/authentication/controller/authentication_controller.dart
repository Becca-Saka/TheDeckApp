import 'dart:async';

import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/services/location_service.dart';

class AuthenticationController extends StateController {
  AuthenticationController({
    required this.authService,
    required this.navigationService,
    required this.appDialog,
  });
  final NavigationService navigationService;
  final AuthenticationService authService;
  final AppDialog appDialog;
  String nameText = '', passwordText = '', emailText = '';
  bool isSocial = false;
  String? path = '';
  String selectedGender = 'Gender';
  String selectedAge = 'Age';
  final genderList = ['Male', 'Female'];
  dynamic socialCredientials;
  dynamic socialtoken;
  bool imageFromSocial = false;

  bool get isLoginButtonEnabled =>
      emailText.isNotEmpty && passwordText.isNotEmpty;

  bool get isRecoverButtonEnabled => emailText.isNotEmpty;
  bool get detailsCheck =>
      nameText.isNotEmpty &&
      selectedAge != 'Age' &&
      selectedGender != 'Gender' &&
      path != '';
  bool get isButtonEnabled =>
      detailsCheck &&
          emailText.isNotEmpty &&
          passwordText.isNotEmpty &&
          !isSocial ||
      isSocial && detailsCheck;

  void updateName(String val) {
    nameText = val;
    notifyListeners();
  }

  void updateEmail(String val) {
    emailText = val;
    notifyListeners();
  }

  void updatePassword(String val) {
    passwordText = val;
    notifyListeners();
  }

  void selectAge(String age) {
    if (age.isNotEmpty) {
      selectedAge = age;
      notifyListeners();
    }
  }

  void selectGender(String? value) {
    if (value != null) {
      selectedGender = value;
      notifyListeners();
    }
  }

  Stream<UserDetails> listenToUserStream() => authService.getUserStream();

  Future<void> doSignUp() async {
    if (!isEmail(emailText)) {
      appDialog.errorSnackbar(msg: 'Please provide a valid email');
    } else if (passwordText.length < 6) {
      appDialog.errorSnackbar(msg: 'Password can\'t be less than 6 characters');
    } else if (path == '') {
      appDialog.errorSnackbar(msg: 'Please select a profile image');
    } else {
      if (hasInternet) {
        await authService.signUp(emailText, passwordText, nameText, selectedAge,
            selectedGender, path!);
      }
    }
  }

  void updateImagePath(String imagePath) {
    path = imagePath;
    notifyListeners();
  }

  Future<void> openImageLocationDialog() async {
    final result = await navigationService.dialog(
      const ImageService(
        isSignUp: true,
      ),
    );
    if (result != null) {
      updateImagePath(result);
    }
  }

//TODO:check all location service call
  Future<void> updateUserlocation() async {
    final isLocationGranted =
        await locator<LocationService>().requestLocationPermmission();
    if (isLocationGranted && hasInternet) {
      await authService.updateUserLocation();
    }
  }

  Future<void> doLogin() async {
    if (!isEmail(emailText)) {
      appDialog.errorSnackbar(msg: 'Pleae provide a valid email');
    } else if (passwordText.length < 6) {
      appDialog.errorSnackbar(msg: 'Password can\'t be less than 6 characters');
    } else {
      if (hasInternet) {
        await authService.login(emailText, passwordText);
      }
    }
  }

  void setDataFromSocial(String name, credientials, token, [String? path]) {
    nameText = name;
    isSocial = true;
    socialCredientials = credientials;
    socialtoken = token;
    if (path != null) {
      imageFromSocial = true;
      this.path = path;
    }

    notifyListeners();
  }

  Future<void> doFacebookLogin() async {
    if (hasInternet) {
      await authService.signInWithFacebook();
    }
  }

  Future<void> doAppleLogin() async {
    if (hasInternet) {
      await authService.signInWithApple();
    }
  }

  Future<void> onContinue() async {
    if (isButtonEnabled) {
      await authService.validateSignInWithApple(selectedAge, selectedGender,
          path!, nameText, socialCredientials, socialtoken,
          imageFromProvider: imageFromSocial);
    }
  }

  Future<void> sendPasswordEmail() async {
    if (!isEmail(emailText)) {
      appDialog.errorSnackbar(msg: 'Pleae provide a valid email');
    } else {
      if (hasInternet) {
        await authService.forgotPassword(emailText);
      }
    }
  }

  void goToSignUp() => navigationService.navigateTo(AppRoutes.signUp);

  void navigateToForgotPassword() =>
      navigationService.navigateTo(AppRoutes.forgotPassword);

  void back() => navigationService.back();

  void clearFields() {
    nameText = '';
    passwordText = '';
    emailText = '';
    selectedAge = 'Age';
    selectedGender = 'Gender';
  }
}
