import 'dart:isolate';

import 'package:alarmku/cores/core_configs/config_theme.dart';
import 'package:alarmku/features/clock/views/clock_view.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'cores/core_services/service_local_notification.dart';

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocalNotification().init();
  tz.initializeTimeZones();
  // final int helloAlarmID = 0;
  runApp(const MyApp());
  // await AndroidAlarmManager.periodic(
  //     const Duration(seconds: 10), helloAlarmID, printHello);
  await AndroidAlarmManager.initialize();
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
