# Flutter Driver App 🚗

A comprehensive food delivery driver application built with Flutter that simulates the complete delivery workflow from order assignment to completion.

## 📱 Features

- **Mock Login System**: Simple email/password authentication
- **Order Management**: View assigned order details with restaurant and customer information
- **Real-time Location Tracking**: GPS location updates every 10 seconds
- **Geofencing**: Smart proximity detection (50m radius) for pickup and delivery
- **Navigation Integration**: Direct Google Maps navigation to destinations
- **Order Flow State Machine**: Complete delivery workflow management
- **Professional UI**: Clean, intuitive interface with consistent design

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Android Studio / VS Code with Flutter extensions
- Physical device or emulator for location testing

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_driver_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
Location permissions are automatically requested when needed. For best results, test on a physical device.

#### iOS  
Location permissions are handled automatically. Physical device recommended for accurate GPS testing.

## 🔐 Login Credentials

The app uses **mock authentication** - you can enter any email and password to log in. Examples:
- Email: `driver@example.com`
- Password: `password123`

*Note: Any text input will work as this is a demonstration app with no backend validation.*

## 🎯 How to Use

1. **Login**: Enter any email and password on the login screen
2. **View Order**: See assigned order details with restaurant and customer information  
3. **Start Journey**: Follow the order flow buttons:
   - `Start Trip` → `Arrived at Restaurant` → `Picked Up` → `Arrived at Customer` → `Complete Delivery`
4. **Navigation**: Tap the navigation icons next to locations to open Google Maps
5. **Geofencing**: Move within 50 meters of locations to enable pickup/delivery buttons
6. **Track Progress**: Monitor your real-time location and distance to destinations

## 📋 Order Flow States

```
Assigned → Trip Started → At Restaurant → Picked Up → At Customer → Delivered
```

- **Geofence Protection**: "Arrived at Restaurant" and "Arrived at Customer" buttons only activate when within 50m
- **Real-time Distance**: Live distance calculation and display
- **Smart UI**: Buttons automatically enable/disable based on proximity

## 🏗 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── order.dart              # Order data model
├── screens/
│   ├── login_screen.dart       # Authentication UI
│   └── assigned_order_screen.dart # Main order management UI
├── services/
│   └── location_service.dart   # GPS location handling
└── util/
    └── order_status_enum.dart  # Order state definitions
```

## 📦 Dependencies

- **geolocator**: GPS location services and distance calculations
- **url_launcher**: Google Maps navigation integration
- **flutter**: Core framework with null safety

## 🔧 Technical Implementation

### Location Service
- **Update Frequency**: Every 10 seconds
- **Accuracy**: High precision GPS
- **Permissions**: Automatic request handling
- **Error Handling**: Comprehensive exception management

### Geofencing Logic
- **Radius**: 50 meters for both restaurant and customer locations
- **Calculation**: Haversine distance formula via geolocator
- **Real-time**: Continuous distance monitoring
- **Debug Logging**: Verbose console output for verification

### State Management
- **Pattern**: StatefulWidget with enum-based state machine
- **Flow Control**: Linear progression through delivery stages
- **UI Updates**: Reactive interface based on location and state

## 🎨 Design Decisions

### UI/UX Choices
- **Color Scheme**: Consistent teal theme throughout
- **Layout**: Card-based design for clear information hierarchy
- **Typography**: Clear, readable fonts with appropriate sizing
- **Interactions**: Intuitive button states (enabled/disabled)

### Architecture Choices
- **Separation of Concerns**: Clear division between UI, business logic, and data
- **Service Pattern**: Dedicated LocationService for GPS operations
- **Model-View**: Clean data models with UI presentation separation
- **Error Handling**: Graceful degradation and user feedback

## 🧪 Testing

### Manual Testing Scenarios
1. **Login Flow**: Verify navigation from login to main screen
2. **Location Permissions**: Test permission request handling
3. **Geofencing**: Verify 50m radius detection accuracy
4. **Navigation**: Test Google Maps integration
5. **State Transitions**: Confirm proper order flow progression

### Device Testing
- **Physical Device**: Recommended for accurate GPS testing
- **Location Simulation**: Use emulator location features for development

## 📱 Demo Data

The app includes realistic demo data:
- **Order ID**: ORD-12345
- **Restaurant**: Gourmet Burger Kitchen (Coordinates: 37.190955, -121.749845)
- **Customer**: Jane Doe (Coordinates: 37.195985, -121.743793)
- **Amount**: $35.75

## 🔍 Debugging

### Location Debugging
The app includes comprehensive console logging:
```
📍 Location Update: Lat: XX.XXXX, Lng: XX.XXXX
--- GEOFENCE CHECK (Restaurant) ---
Current Position: XX.XXXX, XX.XXXX
Distance: XX meters
Can Arrive? true/false
```

### Common Issues
- **Location not updating**: Check device location permissions
- **Buttons not enabling**: Verify GPS accuracy and 50m proximity
- **Maps not opening**: Ensure Google Maps is installed

## 🏆 Assignment Compliance

This project fully implements all required features:
- ✅ Mock login system
- ✅ Order details display
- ✅ Complete order flow state machine
- ✅ 50m geofencing for pickup/delivery
- ✅ Google Maps navigation
- ✅ 10-second location updates
- ✅ Real-time location display
- ✅ Console logging for server simulation

## 🚀 Future Enhancements

Potential improvements for production use:
- Backend API integration
- Push notifications
- Order history
- Multiple simultaneous orders
- Driver performance metrics
- Offline mode support

## 📞 Support

For questions or issues, please check the code comments or review the comprehensive logging output in the console.

---

**Built with ❤️ using Flutter**
