import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/features/authentication/ui/signup_view.dart';
import 'package:thedeck/features/authentication/ui/widgets/age_picker.dart';
import 'package:thedeck/features/authentication/ui/widgets/decorated_text_background.dart';
import 'package:thedeck/features/authentication/ui/widgets/gender_picker.dart';

import '../auth_test_helpers.dart';

GetIt locator = GetIt.instance;

void registerServices() {
  locator.registerLazySingleton(() => MockAuthenticationService());
  locator.registerLazySingleton(() => MockNavigationService());
}

void unregisterServices() {
  locator.unregister<MockAuthenticationService>();
  locator.unregister<MockNavigationService>();
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
    if (locator.isRegistered<AuthenticationController>()) {
      locator.unregister<AuthenticationController>();
    }
    unregisterServices();
  });

  testWidgets(
    "Test that the sign up screen is displayed",
    (WidgetTester tester) async {
      await setUpScreen(
        tester: tester,
        child: const SignUpView(),
        navigationService: navigationService,
        authenticationController: authenticationController,
      );

      // await setUpSignUpScreen(tester);
      expect(find.byType(SignUpView), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(ImageSelector), findsOneWidget);
      expect(find.byType(DecoratedTextBackground), findsOneWidget);
    },
  );

  testWidgets("Test that back button works", (WidgetTester tester) async {
    await setUpScreen(
      tester: tester,
      child: const SignUpView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    verify(() => authenticationController.back()).called(1);
  });

  testWidgets(
      'Test if the AgePicker and GenderPicker widgets update the controller as expected',
      (widgetTester) async {
    await setUpScreen(
      tester: widgetTester,
      child: const SignUpView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    // debugDumpApp();
    when(() => authenticationController.selectedAge).thenReturn('18-24');
    await widgetTester.tap(find.byType(AgePicker), warnIfMissed: false);
    await widgetTester.pumpAndSettle();
    expect(authenticationController.selectedAge, isNot('Age'));

    when(() => authenticationController.selectedGender).thenReturn('Male');
    await widgetTester.tap(find.byType(GenderPicker), warnIfMissed: false);
    await widgetTester.pumpAndSettle();
    expect(authenticationController.selectedGender, isNot('Gender'));
  });
  testWidgets('Test if the authButton widget triggers the doSignUp method',
      (widgetTester) async {
    await setUpScreen(
      tester: widgetTester,
      child: const SignUpView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    await widgetTester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await widgetTester.pumpAndSettle();
    expect(authenticationController.doSignUp(), completes);
  });
  testWidgets(
      'Test if the ImageSelector widget triggers the openImageLocationDialog method',
      (WidgetTester widgetTester) async {
    await setUpScreen(
      tester: widgetTester,
      child: const SignUpView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );
    await widgetTester.tap(find.byType(ImageSelector));

    await widgetTester.pumpAndSettle();
    verify(() => authenticationController.openImageLocationDialog()).called(1);
  });
}
