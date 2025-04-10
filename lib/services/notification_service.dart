import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '/screens/insert_pet_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications(GlobalKey<NavigatorState> navigatorKey) async {
  

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload == 'add_pet') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => const InsertPetScreen()),
        );
      }
    },
  );


  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'reminder_channel_id',
    'Reminder Channel',
    description: 'Channel for pet reminders',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  final androidImplementation = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  bool? canScheduleExactAlarms =
      await androidImplementation?.canScheduleExactNotifications();
  if (canScheduleExactAlarms != true) {
    print('Cannot schedule exact notifications; skipping scheduling');
    return; 
  }

 
  for (int i = 1; i <= 10; i++) {
  final scheduledDate = tz.TZDateTime.from(
    DateTime.now().add(Duration(minutes: 2 * i)),
    tz.local,
  );
  print('Scheduling notification $i for $scheduledDate');
  await flutterLocalNotificationsPlugin.zonedSchedule(
    i,
    'Reminder',
    'Don\'t forget to add a pet!',
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminder Channel',
        channelDescription: 'Channel for pet reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}


Future<void> showNotification({
  required String title,
  required String body,
  String? payload,
}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'reminder_channel_id',
    'Reminder Channel',
    channelDescription: 'Channel for pet reminders',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}