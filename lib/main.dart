import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'screens/bottom_nav_bar.dart';
import 'screens/insert_pet_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(const PermissionRequestApp());
}

class PermissionRequestApp extends StatefulWidget {
  const PermissionRequestApp({super.key});

  @override
  _PermissionRequestAppState createState() => _PermissionRequestAppState();
}

class _PermissionRequestAppState extends State<PermissionRequestApp> {
  bool _isLoading = true;
  String _errorMessage = '';
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndInitialize();
  }

  Future<void> _requestPermissionsAndInitialize() async {
    try {
      await showNotification(
        title: 'Make sure to add your pet!',
        body: 'Click the Add button!',
        payload: 'add_pet',
      );

      print('Requesting POST_NOTIFICATIONS permission...');
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        if (status != PermissionStatus.granted) {
          print('POST_NOTIFICATIONS permission denied');
          setState(() {
            _errorMessage =
                'Notification permission denied. Some features may not work.';
          });
        }
      }
      print('POST_NOTIFICATIONS permission handled');

      print('Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized');

      print('Initializing time zones...');
      tz_data.initializeTimeZones();
      print('Time zones initialized');

      print('Initializing notifications...');
      final navigatorKey = GlobalKey<NavigatorState>();
      await initNotifications(navigatorKey);
      print('Notifications initialized');

      setState(() {
        _isLoading = false;
        _permissionsGranted = true;
      });

      runApp(MyApp(navigatorKey: navigatorKey));
    } catch (e, stackTrace) {
      print('Error during initialization: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize app: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _isLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Requesting permissions...'),
                  ],
                )
              : _permissionsGranted
                  ? const SizedBox()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = '';
                              });
                              _requestPermissionsAndInitialize();
                            },
                            child: const Text('Retry Permissions'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _permissionsGranted = true;
                              });
                              _requestPermissionsAndInitialize();
                            },
                            child: const Text('Continue Without Notifications'),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar(),
    );
  }
}

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
    print('Requesting exact alarm permission...');
    await androidImplementation?.requestExactAlarmsPermission();
    canScheduleExactAlarms =
        await androidImplementation?.canScheduleExactNotifications();
    if (canScheduleExactAlarms != true) {
      print('Exact alarm permission denied');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content:
              const Text('Please grant exact alarm permission for reminders'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      return;
    }
  }

  for (int i = 1; i <= 10; i++) {
    final scheduledDate = tz.TZDateTime.from(
      DateTime.now().add(Duration(minutes: 2 * i)),
      tz.local,
    );
    print('Scheduling notification $i at $scheduledDate');
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
          icon: '@mipmap/ic_launcher', 
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('Notification $i scheduled successfully');
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
    icon: '@mipmap/ic_launcher', // Explicitly set the small icon
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