import 'package:flutter/material.dart';

///Use to make navigation easier, Navigation is possible because we wont be making use of build context we will be using [NavigatorState] key instead
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> closeAndNavigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> closeAllAndNavigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  Future<dynamic> natigate(Widget route, {bool fullscreenDialog = false}) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => route,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  Future<dynamic> dialog(Widget route, {bool isDismissable = false}) {
    return showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: isDismissable,
      barrierLabel: MaterialLocalizations.of(navigatorKey.currentContext!)
          .modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) => route,
    );
  }

  ScaffoldFeatureController snackBar(
    String title,
    String content, {
    Color? colorText,
    Color? backgroundColor,
    String? snackPosition,
  }) {
    return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
        content: SafeArea(
          minimum: snackPosition == 'bottom'
              ? EdgeInsets.only(
                  bottom: MediaQuery.of(navigatorKey.currentContext!)
                          .viewInsets
                          .bottom /
                      3)
              : EdgeInsets.only(
                  top: MediaQuery.of(navigatorKey.currentContext!).padding.top /
                      3),
          bottom: snackPosition == 'bottom',
          top: snackPosition == 'top',
          left: false,
          right: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colorText ?? Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                content,
                style: TextStyle(
                  color: colorText ?? Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void back([Object? arguments]) {
    return navigatorKey.currentState!.pop(arguments);
  }

  ///Pops the stack until the number of times specified
  void close(int times, [int? id]) {
    if (times < 1) {
      times = 1;
    }
    var count = 0;
    var back = navigatorKey.currentState?.popUntil((route) => count++ == times);

    return back;
  }
}
