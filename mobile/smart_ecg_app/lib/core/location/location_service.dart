import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 5),
    );

    return Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  static String formatMapsLink(Position p) {
    return 'https://maps.google.com/?q=${p.latitude},${p.longitude}';
  }
}
