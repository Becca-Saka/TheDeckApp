import 'package:geolocator/geolocator.dart';
import 'package:thedeck/app/routes/const_routes.dart';

class LocationService {
  LocationService({required this.appDialog});
  final AppDialog appDialog;
  Future<Position> checkLocationPermmission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      appDialog.errorSnackbar(msg: 'Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        appDialog.errorSnackbar(msg: 'Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> requestLocationPermmission() async {
    bool serviceEnabled;
    bool isGranted = false;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      appDialog.errorSnackbar(msg: 'Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      isGranted = false;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isGranted = false;
        appDialog.errorSnackbar(
            msg:
                'Location permissions denied, you need to grant access to continue');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isGranted = false;
      final NavigationService navigationService = locator<NavigationService>();
      navigationService.dialog(
        AlertDialog(
          title: const Text('Location permissions denied'),
          content: const Text(
              'You need to grant access to continue. Please go to your settings and manually grant access to the app.'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.appRed),
              ),
              child: const Text('cancel'),
              onPressed: () {
                navigationService.back();
              },
            ),
            TextButton(
              child: const Text('Open App Settings'),
              onPressed: () {
                Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );

      return Future.error('Location permissions are permanently denied');
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      isGranted = true;
    }
    return isGranted;
  }

  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }
}
