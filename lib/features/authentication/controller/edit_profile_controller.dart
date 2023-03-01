import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/ui/account_settings.dart';
import 'package:thedeck/features/home/controller/home_controller.dart';
import 'package:thedeck/features/profile/ui/notifications.dart';
import 'package:thedeck/features/profile/ui/terms_and_privacy.dart';
import 'package:thedeck/models/image_details/image_details.dart';
import 'package:thedeck/shared/app_state.dart';

class EditProfileController extends StateController {
  final AuthenticationService authenticationService;
  final NavigationService navigationService;
  EditProfileController({
    required this.authenticationService,
    required this.navigationService,
    required this.appDialog,
  });
  final AppDialog appDialog;
  // final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final HomeController _homeController = locator<HomeController>();
  UserDetails get currentUser => _homeController.currentUser;
  String nameText = '';
  String age = '0';
  String gender = 'Female', dob = '0';
  String currentImage = '';
  String changedImage = '';
  int profilePictureIndex = 0;
  bool imageUpdated = false, profileImageUpdated = false;
  bool recieveMatchAlert = true, recieveMessageAlert = true;
  bool changeMade = false;
  String prefferedGender = '';
  List<String> newProfileImages = <String>[];
  List<ImageDetails> newProfileImagesMap = [];
  List<ImageDetails> newProfileImagesMapRaw = [];

  void setUserData() {
    prefferedGender = currentUser.prefferedGender!;
    currentImage = currentUser.imageList
        .where((element) => element == currentUser.imageUrl)
        .first;
    profilePictureIndex = currentUser.imageList.indexOf(currentImage);
    changedImage = currentImage;
    nameText = currentUser.name!;
    dob = currentUser.age!;
    age = calculateAge(currentUser.age!);
    gender = currentUser.gender!;
    recieveMatchAlert = currentUser.recieveMatchNotification;
    recieveMessageAlert = currentUser.recieveMessageNotification;
    for (var element in currentUser.imageList) {
      newProfileImagesMap.add(
        setMapField(
          currentUser.imageList.indexOf(element),
          onFirestore: true,
          firebaseUrl: element,
        ),
      );
      newProfileImagesMapRaw.add(
        setMapField(
          currentUser.imageList.indexOf(element),
          onFirestore: true,
          firebaseUrl: element,
        ),
      );
    }
  }

  ImageDetails setMapField(
    int index, {
    bool onFirestore = false,
    bool onLocal = false,
    bool isImageRemoved = false,
    bool isImageUpdated = false,
    String? firebaseUrl,
    String? localUrl,
  }) {
    return ImageDetails(
      index: index,
      onLocal: onLocal,
      firebaseUrl: firebaseUrl,
      localUrl: localUrl,
      isImageRemoved: isImageRemoved,
      isImageUpdated: isImageUpdated,
    );
  }

  void updateNameText(String val) {
    nameText = val;
    notifyListeners();
  }

  void updateGender(String value) {
    gender = value;
  }

  void updateAge(String value) {
    dob = value;
    age = calculateAge(value);
  }

  void updatedPrefferedGender() {
    prefferedGender = prefferedGender == 'Male' ? 'Female' : 'Male';
    notifyListeners();
  }

  void changeImage(String image, int? index) {
    currentImage = image;

    if (index != null) {
      profilePictureIndex = index;
      if (changedImage != currentImage) {
        profileImageUpdated = true;
      }
    }
    notifyListeners();
  }

  void updateMatchNotificationSetting(val) {
    recieveMatchAlert = val;
    notifyListeners();
  }

  void updateMessageNotificationSetting(val) {
    recieveMessageAlert = val;
    notifyListeners();
  }

  void removeImage(int index) {
    newProfileImagesMap.removeWhere((element) => element.index == index);
    newProfileImagesMapRaw[index].isImageRemoved = true;
    newProfileImagesMapRaw[index].isImageUpdated = true;
    imageUpdated = true;

    notifyListeners();
  }

  void _onImageRemoved(int? index, [bool isMain = false]) {
    if (index != null) {
      removeImage(index);
      if (isMain) {
        final urlRef = newProfileImagesMap.toList().first;
        final url = urlRef.firebaseUrl ?? urlRef.localUrl!;
        changeImage(url, index);
        profilePictureIndex = newProfileImagesMap.indexOf(urlRef);
      }
      notifyListeners();
      navigationService.back();
    }
  }

  Future<void> pickImage({int? index, bool isMain = false}) async {
    final result = await navigationService.dialog(
        ImageService(
          isSignUp: true,
          removeImage: () => _onImageRemoved(index, isMain),
          removeVisible: index != null && newProfileImagesMap.length != 1,
        ),
        isDismissable: true);

    if (result != null) {
      imageUpdated = true;

      if (index != null) {
        final old = newProfileImagesMap[index];
        newProfileImagesMap[index] = setMapField(
          index,
          onLocal: true,
          localUrl: result,
          firebaseUrl: old.firebaseUrl,
          onFirestore: old.onFirestore,
        );
        newProfileImagesMapRaw[index] = setMapField(
          index,
          onLocal: true,
          localUrl: result,
          isImageRemoved: true,
          isImageUpdated: true,
          firebaseUrl: old.firebaseUrl,
          onFirestore: old.onFirestore,
        );
      } else {
        newProfileImagesMap.add(setMapField(
          index ?? (newProfileImagesMap.length),
          onLocal: true,
          localUrl: result,
          onFirestore: false,
        ));
        newProfileImagesMapRaw.add(setMapField(
          index ?? (newProfileImagesMap.length),
          onLocal: true,
          localUrl: result,
          onFirestore: false,
          isImageRemoved: false,
          isImageUpdated: true,
        ));
      }
      if (isMain == true) {
        currentImage = result;
        profileImageUpdated = true;
      }
      notifyListeners();
    }
  }

  void checkChangeMade() {
    final user = currentUser;
    if (prefferedGender != user.prefferedGender ||
        dob != user.age! ||
        nameText != user.name ||
        gender != user.gender ||
        recieveMatchAlert != user.recieveMatchNotification ||
        recieveMessageAlert != user.recieveMessageNotification ||
        !listEquals(currentUser.imageList,
            newProfileImagesMap.map((e) => e.firebaseUrl).toList()) ||
        imageUpdated == true ||
        profileImageUpdated == true) {
      changeMade = true;
      currentUser.prefferedGender = prefferedGender;
      currentUser.age = dob;
      currentUser.name = nameText;
      currentUser.gender = gender;
      currentUser.recieveMatchNotification = recieveMatchAlert;
      currentUser.recieveMessageNotification = recieveMessageAlert;
    } else {
      changeMade = false;
    }
  }

  Future<void> updateUser() async {
    checkChangeMade();
    if (changeMade && hasInternet) {
      locator<HomeController>().setAppState(AppState.busy);
      await authenticationService
          .updateUserData(currentUser,
              imageUpdated: imageUpdated,
              profileImageUpdated: profileImageUpdated,
              index: profilePictureIndex,
              imagesMaped: newProfileImagesMapRaw)
          .whenComplete(resetController);
    } else {
      await locator.resetLazySingleton<EditProfileController>();
    }
  }

  FutureOr<void> resetController() async {
    appDialog.successSnackbar(msg: 'Profile updated', title: 'Success');
    await locator.resetLazySingleton<EditProfileController>();
    locator<HomeController>().setAppState(AppState.idle);
  }

  Future<void> logout() async =>
      await authenticationService.logout(currentUser.uid);

  void goBack() => navigationService.back();

  void goToNotification() => navigationService
      .natigate(const NotificationSetting(), fullscreenDialog: true);

  void goToAccountSettings() =>
      navigationService.natigate(AccountSetting(), fullscreenDialog: true);

  void openPrivacyUrl() async {
    const url =
        'https://www.termsfeed.com/live/d09881da-f8c9-443a-b57f-59a72116b69b';

    navigationService.natigate(
      const TermsAndPrivacy(content: url),
      fullscreenDialog: true,
    );
  }

  void openTermsUrl() async {
    const url = 'https://www.websitepolicies.com/policies/view/HkKXJu8M';

    navigationService.natigate(
      const TermsAndPrivacy(content: url),
      fullscreenDialog: true,
    );
  }

  Future<void> showConfirmationDialog() async {
    final isFacebook = authenticationService.isProviderFacebook;
    String passwordText = '';
    final passwordController = TextEditingController();
    appDialog.showDeleteUserDialog(
      isFacebook: isFacebook,
      passwordController: passwordController,
      onConfirm: () {
        if (hasInternet) {
          goBack();

          deleteAccount(password: !isFacebook ? passwordText : null);
        }
      },
    );
  }

  void deleteAccount({String? password}) async => await authenticationService
      .deleteAccount(currentUser, password: password);
}
