import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Checks for location permissions and requests them if not granted.
  /// Returns true if permissions are granted, false otherwise.
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled on the device.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied.
      return false;
    }

    // When we reach here, permissions are granted.
    return true;
  }

  /// Returns a stream that emits the device's current position whenever it changes.
  Stream<Position> getPositionStream() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      // Update the location when the user has moved at least 10 meters.
      distanceFilter: 10,
    );
    // First, check for permissions before trying to get the stream.
    _handleLocationPermission();
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Calculates the distance in meters between two geographic points.
  double getDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
