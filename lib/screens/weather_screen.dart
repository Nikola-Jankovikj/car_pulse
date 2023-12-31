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
        final apiUrl =
            'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${position.latitude},${position.longitude}&days=3';

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

            // Check weather conditions
            bool canWashCar = forecastDays.every((day) =>
            day['day']['condition']['text'].toLowerCase() == 'sunny');

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${location['name']}, ${location['region']}, ${location['country']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: forecastDays.length,
                    itemBuilder: (context, index) {
                      var day = forecastDays[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
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
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: canWashCar ? Colors.green : Colors.red,
                  child: Text(
                    canWashCar
                        ? 'You can wash the car! There is no rain expected in the next 3 days.'
                        : 'Caution: Rain or snow is expected in the next 3 days.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
