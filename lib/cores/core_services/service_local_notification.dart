import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

class ServiceLocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    ///init android settings
    ///
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    ///init ios settings
    ///
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    ///global init setting
    ///
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    ///init
    ///
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  ///route for app lifecycle resume, pause, inactive
  ///
  Future selectNotification(String? payload) async {
    Get.toNamed('$payload');
  }

  ///init bool receive
  ///
  Future onDidReceiveLocalNotification(
      int vi, String? vs, String? vs2, String? payload) async {
    //Handle notification tapped logic here
  }

  ///init for handle lifecycle detached
  ///
  void initHandleClose() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails != null) {
      if (notificationAppLaunchDetails.payload != null) {
        Get.toNamed('${notificationAppLaunchDetails.payload.toString()}');
        // Fluttertoast.showToast(
        //     msg: notificationAppLaunchDetails.payload.toString());
      }
    }
  }

  void fireAlarm() {
    print('Alarm Fired at${DateTime.now()}');
  }

  ///schedule push
  ///
  void pushSchedule({
    required int id,
    String? title,
    String? subtitle,
    String? payload,
    required DateTime dateTime,
  }) async {
    // AndroidAlarmManager.cancel(20);
    AndroidAlarmManager.periodic(Duration(seconds: 5), 20, fireAlarm);

    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails('id', 'channel',
    //         importance: Importance.max,
    //         priority: Priority.high,
    //         enableLights: true,
    //         enableVibration: true,
    //         playSound: true,
    //         ticker: 'ticker',
    //         showWhen: false);

    // const IOSNotificationDetails iosPlatformChannelSpecifics =
    //     IOSNotificationDetails(threadIdentifier: 'thread_id');

    // var localTime = tz.TZDateTime(tz.local, dateTime.year, dateTime.month,
    //     dateTime.day, dateTime.hour, dateTime.minute);

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     id,
    //     "$title",
    //     "$subtitle",
    //     tz.TZDateTime.parse(tz.local, dateTime.toString()),
    //     const NotificationDetails(
    //         android: androidPlatformChannelSpecifics,
    //         iOS: iosPlatformChannelSpecifics),
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     payload: payload);
  }

  ///cancel by id
  ///
  Future cancelByID(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  ///cancel all
  ///
  Future cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
