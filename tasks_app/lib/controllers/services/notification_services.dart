import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await requestNotificationPermissions();

    // Initialize timezone data
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));

    // Initialize notification settings for Android and iOS
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> requestNotificationPermissions() async {
    final bool isGranted = await localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions() ??
        false;
    if (!isGranted) {
      final bool result = await localNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .requestNotificationsPermission() ??
          false;

      if (!result) {
        log('Notification permission not granted');
      }
    }
  }

  Future<void> scheduleTaskNotification({
    required String title,
    required String body,
    required DateTime scheduledDateTime, // Task's date and time
  }) async {
    // Create notification details for Android and iOS
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      icon: "@mipmap/ic_launcher",
      channelDescription: 'Notifications for scheduled tasks',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Convert DateTime to TZDateTime (timezone-aware)
    final tz.TZDateTime scheduledTZDateTime =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    // Schedule the notification
    await localNotificationsPlugin.zonedSchedule(
      DateTime.now().microsecondsSinceEpoch ~/
          20000000, // Unique ID for the notification
      title, // Title of the notification
      body, // Body of the notification
      scheduledTZDateTime, // Date and time when the notification should appear
      platformDetails, // Notification details (Android/iOS)
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Match exact time components (hour, minute)
    );
  }
}
