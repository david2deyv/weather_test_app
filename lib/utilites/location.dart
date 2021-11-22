import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission != LocationPermission.denied ||
        locationPermission != LocationPermission.deniedForever) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
          forceAndroidLocationManager: true,
        );
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        throw 'Something goes wrong: $e';
      }
    } else {
      await Geolocator.requestPermission();
    }
  }
}
