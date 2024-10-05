import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings('mipmap/ic_launcher');

  final DarwinInitializationSettings _iOSInitializationSettings = DarwinInitializationSettings();

  /// Initialise Notification
  initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(android: _androidInitializationSettings,iOS: _iOSInitializationSettings);
    await _notificationsPlugin.initialize(initializationSettings);
  }


  /// Send Notification
  void sendNotification(String? title, String? body) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }


  /// Schedule Notification
  /// Schedule Notification without specifying the scheduled time
  /// Schedule Notification without specifying the scheduled time
  Future<void> scheduleNotification(String title, String body) async {
    // Initialize time zones (if not already initialized)
    tz.initializeTimeZones();

    final location = tz.getLocation('Asia/Dhaka'); // Replace with your desired timezone

    final tzScheduledDateTime = tz.TZDateTime.now(location).add(const Duration(seconds: 5)); // Replace '5' with your desired delay

    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    final int notificationId = tzScheduledDateTime.millisecondsSinceEpoch ~/ 1000;

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tzScheduledDateTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }


  /// Stopped Notification
  void stoppedNotification() async {

    /// Id dhore stop hobe
    await _notificationsPlugin.cancel(0).then((value) =>
        Get.snackbar(
          'Message',
          'Reminder delete successfully',
          backgroundColor:
          Colors.black, // Replace with your desired color
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM, // Positioned at the bottom
        ));
    print("Stopped");
  }

}