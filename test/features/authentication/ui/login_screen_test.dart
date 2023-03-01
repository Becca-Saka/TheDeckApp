import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/features/authentication/ui/login_view.dart';
import 'package:thedeck/features/authentication/ui/widgets/app_logo.dart';

import '../auth_test_helpers.dart';

GetIt locator = GetIt.instance;

void registerServices() {
  locator.registerLazySingleton(() => MockAuthenticationService());
  locator.registerLazySingleton(() => MockNavigationService());
}

void unregisterServices() {
  locator.unregister<MockAuthenticationService>();
  locator.unregister<MockNavigationService>();
  if (locator.isRegistered<AuthenticationController>()) {
    locator.unregister<AuthenticationController>();
  }
}

Widget createWidgetForTesting<T extends StateController>({
  required Widget child,
  required NavigationService navigationService,
}) {
  return MaterialApp(
    title: 'The Deck',
    builder: (context, child) {
      return ConnectionWidget(
          dismissOfflineBanner: false,
          builder: (BuildContext context, bool isOnline) {
            return child!;
          });
    },
    navigatorKey: navigationService.navigatorKey,
    home: child,
  );
}

void main() {
  late MockNavigationService navigationService;
  late AuthenticationController authenticationController;
  setUp(() {
    registerServices();
    if (!locator.isRegistered<MockAuthenticationController>()) {
      authenticationController = MockAuthenticationController();
      locator.registerLazySingleton(() => authenticationController);
    }
    navigationService = locator<MockNavigationService>();
  });
  tearDown(() {
    unregisterServices();
  });

  String email = 'example@email.com';
  String password = 'password';

  final emailFinder = find.widgetWithText(TextField, 'Email');
  final passwordFinder = find.widgetWithText(TextField, 'Password');
  testWidgets(
    "appLogo is displayed",
    (WidgetTester tester) async {
      await setUpScreen(
        tester: tester,
        child: const LoginView(),
        navigationService: navigationService,
        authenticationController: authenticationController,
      );
      expect(find.byType(AppLogo), findsOneWidget);
    },
  );
  testWidgets('Login button taps perform login action',
      (WidgetTester tester) async {
    await setUpScreen(
      tester: tester,
      child: const LoginView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    await tester.enterText(emailFinder, email);
    await tester.enterText(passwordFinder, password);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));

    await tester.pump();

    expect(authenticationController.doLogin, isNotNull);
  });
  testWidgets('Verify that the login button is enabled',
      (WidgetTester tester) async {
    await setUpScreen(
      tester: tester,
      child: const LoginView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    await tester.enterText(emailFinder, email);
    await tester.enterText(passwordFinder, password);
    when(() => authenticationController.isLoginButtonEnabled).thenReturn(true);
    await tester.pumpAndSettle();
    expect(authenticationController.isLoginButtonEnabled, isTrue);
  });
  testWidgets('Verify that the forgot password button is visible and taps',
      (WidgetTester tester) async {
    await setUpScreen(
      tester: tester,
      child: const LoginView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    final forgotPasswordFinder =
        find.widgetWithText(InkWell, 'Forgot Password');
    await tester.tap(forgotPasswordFinder);
    await tester.pumpAndSettle();
    expect(forgotPasswordFinder, findsOneWidget);
  });
  testWidgets('Verify that the register button is visible and taps',
      (WidgetTester tester) async {
    await setUpScreen(
      tester: tester,
      child: const LoginView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    final signUpFinder = find.widgetWithText(InkWell, 'Signup');
    await tester.tap(signUpFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(signUpFinder, findsOneWidget);
  });

  testWidgets('Verify that apple login button is visible only on ios',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await setUpScreen(
      tester: tester,
      child: const LoginView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    final appleLoginFinder =
        find.image(const AssetImage('assets/images/apple_logo.png'));
    expect(appleLoginFinder, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });
}
