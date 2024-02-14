import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:car_pulse/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() async{
  AwesomeNotifications().initialize(
    // Add your custom settings here, if needed
    null, // Your app icon resource
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Channel for basic notifications',
        defaultColor: Colors.green,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
      ),
    ],
  );
  bool isAllowedToSendNotifications = await AwesomeNotifications().isNotificationAllowed();
  if (isAllowedToSendNotifications){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
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
