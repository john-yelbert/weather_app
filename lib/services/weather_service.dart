import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final String baseUrl = "http://10.0.2.2:5000/weather"; /*10.0.2.2*/

  // Fetch weather by city
  Future<Map<String, dynamic>> getWeatherByCity(String city) async {
    final response = await http.get(Uri.parse("$baseUrl?city=$city"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"error": "Failed to fetch weather data"};
    }
  }

  // Fetch weather by location
  Future<Map<String, dynamic>> getWeatherByLocation() async {
    try {
      Position position = await _determinePosition();
      final response = await http.get(Uri.parse("$baseUrl?lat=${position.latitude}&lon=${position.longitude}"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to fetch weather data"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // Get user’s current location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    // Get current position
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
