import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thedeck/app/locator.dart';
import 'package:thedeck/app/routes/app_pages.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/services/internet_services.dart';
import 'package:thedeck/services/navigation_services.dart';
import 'package:thedeck/shared/const_color.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationController>(
          create: (context) => locator<AuthenticationController>(),
        ),
      ],
      child: MaterialApp(
        title: 'The Deck',
        theme: ThemeData(
          primaryColor: const Color(0xffFF5757),
          colorScheme: ColorScheme.light(primary: AppColors.appRed),
          fontFamily: 'Poppins',
        ),
        builder: (context, child) {
          return ConnectionWidget(
              dismissOfflineBanner: false,
              builder: (BuildContext context, bool isOnline) {
                return child!;
              });
        },
        navigatorKey: locator<NavigationService>().navigatorKey,
        initialRoute: AppPages.initial,
        onGenerateRoute: AppPages.onGenerateRoute,
      ),
    );
  }
}
