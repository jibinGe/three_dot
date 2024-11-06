import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LocationService {
  static Future<Position?> getLocation() async {
    try {
      // Check if location permissions are granted
      if (await checkLocationPermission()) {
        debugPrint("Position called");
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        debugPrint("Position get");
        return position;
      } else {
        // Handle case where permissions are not granted
        debugPrint("Location permissions are not granted");
        return null;
      }
    } catch (e) {
      // Handle any exceptions here
      print("Error getting location: ${e.toString()}");
      return null; // Return null if exception occurs
    }
  }

  static Future<bool> checkLocationPermission() async {
    // Check if location permission is granted
    PermissionStatus permission = await Permission.location.request();
    return permission == PermissionStatus.granted;
  }

  static void launchMap(double latitude, double longitude) async {
    try {
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunchUrlString(googleMapsUrl)) {
        await launchUrlString(googleMapsUrl);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e) {
      print("Cant launch url :$e");
    }
  }
}
