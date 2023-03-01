import 'package:flutter/material.dart';
import 'package:thedeck/app/locator.dart';
import 'package:thedeck/app/routes/app_routes.dart';
import 'package:thedeck/services/authentication_service.dart';
import 'package:thedeck/services/internet_services.dart';
import 'package:thedeck/services/navigation_services.dart';

class StartUp extends StatefulWidget {
  const StartUp({Key? key}) : super(key: key);
  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  bool isUserLoggedIn = false;
  final AuthenticationService _authService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<Future> checkLogin() async {
    if (!ConnectionUtil.instance.hasConnection) {
      final user = await _authService.checkLogin();

      if (user != null) {
        if (user.lat != null && user.long != null) {
          return _navigationService.closeAllAndNavigateTo(AppRoutes.home);
        } else {
          return _navigationService.closeAllAndNavigateTo(AppRoutes.exp);
        }
      }
    }
    return _navigationService.closeAllAndNavigateTo(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Image.asset('assets/images/Splash.png'),
        ),
      ),
    );
  }
}
