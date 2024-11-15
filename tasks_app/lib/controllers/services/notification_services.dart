import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialisation du service de notification
  Future<void> initialize() async {
    await requestNotificationPermissions();

    // Initialiser les données de fuseau horaire
    tz.initializeTimeZones();

    // Définir la localisation du fuseau horaire local
    tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));

    // Initialiser les paramètres de notification pour Android et iOS
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialiser le plugin de notifications
    await localNotificationsPlugin.initialize(initSettings);
  }

  /// Demander l'autorisation d'envoyer des notifications
  Future<void> requestNotificationPermissions() async {
    final bool isGranted = await localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions() ??
        false;

    // Si l'autorisation n'est pas accordée sur iOS, demander sur Android
    if (!isGranted) {
      final bool result = await localNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .requestNotificationsPermission() ??
          false;

      if (!result) {
        log('Permission de notification non accordée'); // Log en cas d'échec
      }
    }
  }

  /// Planifier une notification pour une tâche spécifique
  Future<void> scheduleTaskNotification({
    required String title,
    required String body,
    required DateTime scheduledDateTime, // Date et heure de la tâche
  }) async {
    // Créer les détails de la notification pour Android et iOS
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_channel_id', // ID du canal de notification
      'Notifications de Tâches', // Nom du canal
      icon: "@mipmap/ic_launcher",
      channelDescription: 'Notifications pour les tâches planifiées',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Convertir DateTime en TZDateTime (avec prise en compte du fuseau horaire)
    final tz.TZDateTime scheduledTZDateTime =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    // Planifier la notification à l'heure spécifiée
    await localNotificationsPlugin.zonedSchedule(
      DateTime.now().microsecondsSinceEpoch ~/
          20000000, // ID unique pour la notification
      title, // Titre de la notification
      body, // Corps de la notification
      scheduledTZDateTime, // Date et heure auxquelles la notification doit apparaître
      platformDetails, // Détails spécifiques à la plateforme (Android/iOS)
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
