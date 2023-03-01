import 'dart:async';

import 'package:rxdart/rxdart.dart' as my_rx;
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/chat/controller/chat_controller.dart';
import 'package:thedeck/services/firebase_firestore_services.dart';
import 'package:thedeck/shared/app_state.dart';

import '../../authentication/controller/authentication_controller.dart';

class HomeController extends StateController {
  UserDetails _currentUser = UserDetails();
  UserDetails get currentUser => _currentUser;
  List newMatch = [];
  Timer? _timer;
  var countDownTimer = '8:00';
  var testNo = 6;
  int _start = 480;
  final firestoreService = FirestoreServices();
  int lastMatchedTime = 0;
  final AuthenticationController _authController =
      locator<AuthenticationController>();
  final NavigationService _navigationService = locator<NavigationService>();
  late StreamSubscription<UserDetails> _userDetailsSubscription;
  bool showTimer = true, _timerStarted = false;
  final List<MatchDetails> _matchedList = [];
  List<MatchDetails> get matchedList => _matchedList;

  //TODO:confirm countdown timer works on ios
  Stream<List<dynamic>> combineStream() {
    return my_rx.CombineLatestStream.list([
      firestoreService.getCurrentlyMatchedUserStream(),
      firestoreService.getUsersDetail(),
    ]);
  }

  void onClose() {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    }
    _userDetailsSubscription.cancel();
    _authController.dispose();
  }

  void setUser(UserDetails userDetails) {
    _currentUser = userDetails;
  }

  void setUserData() {
    lastMatchedTime = currentUser.lastMatchedTime.millisecondsSinceEpoch;
    calculateLastMatchedTime();

    setUserStreamData();
  }

  void setUserStreamData() {
    _userDetailsSubscription =
        _authController.listenToUserStream().listen((user) async {
      _currentUser = user;
      calculateLastMatchedTime();

      notifyListeners();
    });
  }

  void calculateLastMatchedTime() {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
        currentUser.lastMatchedTime.millisecondsSinceEpoch);
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 480) {
      _start = 480 - difference.inMinutes;

      countDownTimer = _getDuration(Duration(minutes: _start));
    } else {
      _start = 0;
      countDownTimer = '0:00';
    }
    if (_start != 0 && _timerStarted == false) {
      startTimer();
    }
  }

  void startTimer() {
    if (currentUser.currentMatches.length != 6 && _timerStarted == false) {
      showTimer = true;
      const oneMin = Duration(minutes: 1);
      _timerStarted = true;
      _timer = Timer.periodic(
        oneMin,
        (Timer timer) {
          if (_start == 0) {
            timer.cancel();
            _start = 480;
            _timerStarted = false;
          } else {
            _start--;
          }

          countDownTimer = _getDuration(Duration(minutes: _start));
          notifyListeners();
        },
      );
    } else {
      showTimer = false;
    }
  }

  String _getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String oneDigits(int n) => n.toString().padLeft(1, "0");
    String oneDigitHours = oneDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "$oneDigitHours:$twoDigitMinutes";
  }

  Future<bool> showConfirmationDialog(UserDetails e) async =>
      await locator<AppDialog>().showRemoveFromDeckDialog(e.name!);

  Future<void> removeMatch(UserDetails removeUser, MatchDetails matchDetails) =>
      firestoreService.removeMatch(removeUser, matchDetails, currentUser);

  bool getIsNewMatch(MatchDetails matchDetails) =>
      matchDetails.isNew![currentUser.uid]!;

  void updateIsNew(MatchDetails matchDetails) async {
    if (matchDetails.isNew![currentUser.uid!] == true) {
      await firestoreService.updateIsNew(matchDetails);
    }
  }

  void navigateToChat(UserDetails user, MatchDetails matchDetails) {
    locator<ChatController>().onInit(user, matchDetails);
    _navigationService.navigateTo(AppRoutes.chat);
    updateIsNew(matchDetails);
  }

  void navigateToEditProfile() {
    if (state == AppState.idle) {
      _navigationService.navigateTo(AppRoutes.editProfile);
    }
  }

  bool? isRead;
  String? messageId;
}
