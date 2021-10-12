import 'dart:isolate';
import 'dart:ui';

import 'package:alarmku/cores/core_configs/config_theme.dart';
import 'package:alarmku/features/clock/views/clock_view.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'cores/core_services/service_local_notification.dart';

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
// }

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ServiceLocalNotification().init();
  tz.initializeTimeZones();
  // final int helloAlarmID = 0;

  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            enableVibration: true,
            channelShowBadge: true,
            defaultPrivacy: NotificationPrivacy.Public,
            onlyAlertOnce: true,
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            importance: NotificationImportance.Max,
            locked: true)
      ]);
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ConfigTheme.themeData,
      home: Container(
          color: Colors.white, alignment: Alignment.center, child: ClockView()),
    );
  }
}
