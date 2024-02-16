import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../model/car.dart';

class NotificationService {
  static void initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Colors.green,
          ledColor: Colors.white,
        ),
      ],
    );
  }

  static void scheduleNotification(
      int carId, String carMake, String carModel, DateTime serviceDate) {
    String serviceText = "${serviceDate.day}.${serviceDate.month}.${serviceDate.year}";
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: carId,
        channelKey: 'basic_channel',
        title: 'Service Reminder',
        body: 'Upcoming service for $carMake $carModel on $serviceText',
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        //interval: 10,
        weekday: serviceDate.weekday,
        hour: serviceDate.hour,
        minute: serviceDate.minute,
        second: serviceDate.second,
        allowWhileIdle: true,
        repeats: false,
      ),
    );
  }

  static void updateNotification(int carId, DateTime newServiceDate, Car car) {
    // Cancel the existing notification
    AwesomeNotifications().cancel(carId);

    // Schedule a new notification with the updated service date
    // Assuming carMake and carModel are accessible here
    // You may need to adjust this based on your implementation
    scheduleNotification(carId, car.make, car.model, newServiceDate);
  }

  static void cancelNotification(int carId) {
    AwesomeNotifications().cancel(carId);
  }
}
