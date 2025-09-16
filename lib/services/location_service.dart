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

  /// Returns a stream that emits the device's current position every 10 seconds.
  Stream<Position> getPositionStream() {
    // First, check for permissions before trying to get the stream.
    _handleLocationPermission();

    // Create a stream controller to manage our custom time-based location updates
    late StreamController<Position> streamController;
    Timer? locationTimer;

    streamController = StreamController<Position>(
      onListen: () {
        // Start the timer when someone listens to the stream
        locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
          try {
            final LocationSettings locationSettings = LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 0,
            );

            final Position position = await Geolocator.getCurrentPosition(
              locationSettings: locationSettings,
            );

            if (!streamController.isClosed) {
              streamController.add(position);
            }
          } catch (e) {
            if (!streamController.isClosed) {
              streamController.addError(e);
            }
          }
        });

        // Get initial position immediately
        _getInitialPosition(streamController);
      },
      onCancel: () {
        locationTimer?.cancel();
        streamController.close();
      },
    );

    return streamController.stream;
  }

  /// Gets the initial position when stream starts
  Future<void> _getInitialPosition(
    StreamController<Position> controller,
  ) async {
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (!controller.isClosed) {
        controller.add(position);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
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
