import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/order.dart';
import '../services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignedOrderScreen extends StatefulWidget {
  const AssignedOrderScreen({super.key});

  @override
  State<AssignedOrderScreen> createState() => _AssignedOrderScreenState();
}

class _AssignedOrderScreenState extends State<AssignedOrderScreen> {
  // Creating a hardcoded "dummy" order for display.
  // We are using realistic coordinates for testing navigation later.
  final Order assignedOrder = Order(
    id: 'ORD-12345',
    restaurantName: 'Gourmet Burger Kitchen',
    // Coordinates for the Googleplex in Mountain View, CA
    restaurantLat: 37.4219999,
    restaurantLng: -122.0840575,
    customerName: 'Jane Doe',
    // Coordinates for Stanford University
    customerLat: 37.4274745,
    customerLng: -122.1702937,
    orderAmount: 35.75,
  );

  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    // Listen to the stream of position updates from our service
    _positionStreamSubscription = _locationService.getPositionStream().listen((
      Position position,
    ) {
      // Update the UI with the new position
      setState(() {
        _currentPosition = position;
      });

      print(
        '📍 Location Update: Lat: ${position.latitude}, Lng: ${position.longitude}',
      );
    });
  }

  void _launchMaps(double lat, double lng) async {
    // Construct the Google Maps URL.
    // The 'query' parameter is used to search for the lat,lng pair.
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    try {
      // Check if the URL can be launched.
      if (await canLaunchUrl(googleMapsUrl)) {
        // Launch the URL. `launchMode` is optional but good practice.
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // If the URL can't be launched, show an error.
        // (This is unlikely for a valid https URL)
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e) {
      // Optional: Show a snackbar or dialog to the user if launching fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open maps: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${assignedOrder.id}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section for Restaurant Details
            _buildLocationCard(
              title: 'Restaurant',
              name: assignedOrder.restaurantName,
              lat: assignedOrder.restaurantLat,
              lng: assignedOrder.restaurantLng,
            ),
            const SizedBox(height: 16),

            // Section for Customer Details
            _buildLocationCard(
              title: 'Customer',
              name: assignedOrder.customerName,
              lat: assignedOrder.customerLat,
              lng: assignedOrder.customerLng,
            ),
            const SizedBox(height: 24),

            // Section for Order Amount
            Center(
              child: Text(
                'Order Amount: \$${assignedOrder.orderAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            _buildDriverLocationStatus(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverLocationStatus() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          _currentPosition != null
              ? 'My Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
              : 'Fetching driver location...',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  // A reusable helper widget to display location info in a Card.
  Widget _buildLocationCard({
    required String title,
    required String name,
    required double lat,
    required double lng,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        // We wrap the content in a Row to place the button next to the text.
        child: Row(
          children: [
            // The Expanded widget makes the Column take up all available horizontal space.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(name, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    'Coordinates: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // This is the new navigation button.
            IconButton(
              icon: const Icon(Icons.navigation, color: Colors.teal, size: 30),
              onPressed: () => _launchMaps(lat, lng),
            ),
          ],
        ),
      ),
    );
  }
}
