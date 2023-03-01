import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/features/authentication/ui/explanation_view.dart';

import '../auth_test_helpers.dart';

GetIt locator = GetIt.instance;

void registerServices() {
  locator.registerLazySingleton(() => MockNavigationService());
}

void unregisterServices() {
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

  testWidgets("Test that back button works", (WidgetTester tester) async {
    await setUpScreen(
      tester: tester,
      child: const ExplanationView(),
      navigationService: navigationService,
      authenticationController: authenticationController,
    );

    expect(find.textContaining('A full deck is 6 matches.'), findsOneWidget);
  });
  tearDown(() {
    unregisterServices();
  });
}
