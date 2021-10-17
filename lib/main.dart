import 'dart:isolate';
import 'dart:ui';

import 'package:alarmku/cores/core_configs/config_theme.dart';
import 'package:alarmku/cores/core_services/service_local_storage.dart';
import 'package:alarmku/features/clock/views/clock_view.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;

const String isolateName = 'isolate';

final ReceivePort port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocalStorage().init();

  tz.initializeTimeZones();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  AwesomeNotifications().initialize(null, [
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
          color: Colors.white,
          alignment: Alignment.center,
          child: const ClockView()),
    );
  }
}
