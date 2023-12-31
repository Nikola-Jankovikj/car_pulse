import 'package:car_pulse/screens/addServiceInfo.dart';
import 'package:car_pulse/screens/main_screen.dart';
import 'package:car_pulse/screens/addServiceInfo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}
