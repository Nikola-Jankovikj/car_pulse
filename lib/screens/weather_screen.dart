import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = _getWeatherData();
  }

  Future<Map<String, dynamic>> _getWeatherData() async {
    final apiKey = '53971e78a15c489cbd5151551233112'; // Replace with your weatherapi.com API key
    final permissionStatus = await _requestLocationPermission();

    switch (permissionStatus) {
      case PermissionStatus.granted:
        final position = await _getCurrentLocation();
        final apiUrl = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${position.latitude},${position.longitude}&days=3';

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load weather data');
        }
      case PermissionStatus.denied:
        _showPermissionDeniedDialog();
        throw Exception('Location permission denied');
      case PermissionStatus.permanentlyDenied:
        _showPermissionDeniedDialog();
        throw Exception('Location permission permanently denied');
      default:
        throw Exception('Unexpected permission status');
    }
  }

  Future<PermissionStatus> _requestLocationPermission() async {
    final status = await Permission.location.request();
    return status;
  }

  Future<Position> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text('Please grant location permission to access weather information.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              openAppSettings(); // Open app settings for the user to grant permission
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final forecast = snapshot.data as Map<String, dynamic>;
            final location = forecast['location'];
            final forecastDays = forecast['forecast']['forecastday'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${location['name']}, ${location['region']}, ${location['country']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  for (var day in forecastDays)
                    ListTile(
                      title: Text('Date: ${day['date']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Max Temperature: ${day['day']['maxtemp_c']}°C'),
                          Text('Min Temperature: ${day['day']['mintemp_c']}°C'),
                          Text('Condition: ${day['day']['condition']['text']}'),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}
