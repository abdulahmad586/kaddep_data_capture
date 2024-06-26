import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> determinePosition({bool bestAccuracy = false}) async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Service is not enabled');
        return Future.error(
            'Location services are disabled, please enable phone location');
      }
      print("Determining permission");
      permission = await Geolocator.checkPermission();
      print("Determined permission");
      if (permission == LocationPermission.denied) {
        print('permission is not granted');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      print("Determining position");
      if (permission == LocationPermission.deniedForever) {
        print('Permission denied forever');
        return Future.error(
            'Location permissions are permanently denied for this app, please check app settings and grant permission');
      }

      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy:
          bestAccuracy ? LocationAccuracy.best : LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 30));
      return position;
    } catch (e) {
      print('Error getting location ${e.toString()}');
      return Future.error('Unable to determine location at the moment');
    }
  }
}
