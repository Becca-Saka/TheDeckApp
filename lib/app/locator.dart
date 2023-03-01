import 'package:get_it/get_it.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/authentication.dart';
import 'package:thedeck/features/chat/controller/chat_controller.dart';
import 'package:thedeck/features/home/controller/home_controller.dart';
import 'package:thedeck/services/firebase_auth_service.dart';
import 'package:thedeck/services/firebase_firestore_services.dart';
import 'package:thedeck/services/location_service.dart';

GetIt locator = GetIt.instance;

///Used to inject service so we can acess anywhere
void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreServices());

  locator.registerLazySingleton(() => AppDialog(
        navigationService: locator<NavigationService>(),
      ));

  locator.registerLazySingleton(
      () => LocationService(appDialog: locator<AppDialog>()));

  locator.registerLazySingleton(() => AuthenticationService(
        firebaseAuthService: locator<FirebaseAuthService>(),
        firestoreService: locator<FirestoreServices>(),
        navigationService: locator<NavigationService>(),
        appDialog: locator<AppDialog>(),
      ));

  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => AuthenticationController(
        authService: locator<AuthenticationService>(),
        navigationService: locator<NavigationService>(),
        appDialog: locator<AppDialog>(),
      ));
  locator.registerLazySingleton(() => HomeController());
  locator.registerLazySingleton(() => EditProfileController(
        navigationService: locator<NavigationService>(),
        authenticationService: locator<AuthenticationService>(),
        appDialog: locator<AppDialog>(),
      ));
  locator.registerLazySingleton(() => ChatController(
        navigationService: locator<NavigationService>(),
        appDialog: locator<AppDialog>(),
      ));
}

void resetLocator() {
  locator.resetLazySingleton<AuthenticationController>();
  locator.resetLazySingleton<HomeController>();
  locator.resetLazySingleton<EditProfileController>();
  locator.resetLazySingleton<ChatController>();
  locator.resetLazySingleton<FirestoreServices>();
  locator.resetLazySingleton<NavigationService>();
}
