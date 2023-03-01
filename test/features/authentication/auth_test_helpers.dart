import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/services/firebase_auth_service.dart';
import 'package:thedeck/services/firebase_firestore_services.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockFirestoreServices extends Mock implements FirestoreServices {}

class MockNavigationService extends Mock implements NavigationService {}

class MockAppDialog extends Mock implements AppDialog {}

class MockAuthenticationController extends Mock
    implements AuthenticationController {}

Widget createWidgetForTesting<T extends StateController>({
  required Widget child,
  required NavigationService navigationService,
}) {
  return MaterialApp(
    title: 'The Deck',
    builder: (context, child) {
      return ConnectionWidget(
          key: UniqueKey(),
          dismissOfflineBanner: false,
          builder: (BuildContext context, bool isOnline) {
            return child!;
          });
    },
    navigatorKey: navigationService.navigatorKey,
    home: child,
  );
}

Future<void> setUpScreen({
  required WidgetTester tester,
  required Widget child,
  required NavigationService navigationService,
  required AuthenticationController authenticationController,
}) async {
  log('getting called by ${child.runtimeType}');
  when(() => navigationService.navigatorKey)
      .thenReturn(GlobalKey<NavigatorState>());
  when(() => authenticationController.nameText).thenReturn('');
  when(() => authenticationController.selectedAge).thenReturn('Age');
  when(() => authenticationController.selectedGender).thenReturn('Gender');
  when(() => authenticationController.path).thenReturn('');
  when(() => authenticationController.emailText).thenReturn('');
  when(() => authenticationController.passwordText).thenReturn('');
  when(() => authenticationController.isLoginButtonEnabled).thenReturn(false);
  when(() => authenticationController.isSocial).thenReturn(false);
  when(() => authenticationController.imageFromSocial).thenReturn(false);
  when(() => authenticationController.isButtonEnabled).thenReturn(false);
  when(() => authenticationController.doSignUp())
      .thenAnswer((invocation) => Future<void>.value());
  when(() => authenticationController.doLogin())
      .thenAnswer((invocation) => Future<void>.value());
  when(() => authenticationController.openImageLocationDialog())
      .thenAnswer((invocation) => Future<void>.value());

  await tester.pumpWidget(createWidgetForTesting(
    navigationService: navigationService,
    child: child,
  ));
}
