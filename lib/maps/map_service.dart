import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class getLocation {
  /// Request Location permission, return GeolocationStatus object
  static Future<LocationPermission> requestPermissions() async {
    return await Geolocator.requestPermission();
  }

  /// get location status: GPS enabled and the permission status with GeolocationStatus
  // static Future<LocationStatus> checkLocationStatus() async {
  //   final status = await Geolocator.checkPermission();
  //   final enabled = await Geolocator.isLocationServiceEnabled();
  //   return LocationStatus(enabled, status);
  // }

  Future<String> getCurrentLocation(bool _isHome) async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print('location: ${position.latitude}');
    List<Placemark> addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    var first = addresses.first;
    print("${first.name} : ${first..administrativeArea}");
    if (_isHome) {
      return ('${first.subAdministrativeArea}, ${first.thoroughfare} ,${first.street}');
    }
    return ('${first.country}, ${first.subAdministrativeArea}, ${first.street}');
  }

  Future<List<double>> getLatLong() async {
    List<double> latlong = [];

    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    latlong.add(position.latitude);
    latlong.add(position.longitude);

    return latlong;
  }
}
