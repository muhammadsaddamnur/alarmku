import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:alarmku/cores/core_services/servcie_debounce.dart';
import 'package:alarmku/main.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ringtone_player/ringtone_player.dart';

class ClockController extends GetxController {
  Rx<Timer> timer = Timer(const Duration(seconds: 0), () {}).obs;
  Rx<DateTime> dateTime = DateTime.now().obs;

  Rx<FixedExtentScrollController> hourController =
      FixedExtentScrollController(initialItem: 0).obs;

  @override
  void onInit() {
    timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      dateTime.value = DateTime.now();
    });
    super.onInit();
    port.listen((_) async => await _incrementCounter());

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      RingtonePlayer.stop();
      if (receivedNotification.buttonKeyPressed == '1') {
        print('wkwkwk');
      }
      Get.toNamed('/');
    });
  }

  Future<void> _incrementCounter() async {
    log('Increment counter!');
  }

  static SendPort? uiSendPort;

  static Future<void> callback() async {
    print('Alarm fired!');

    RingtonePlayer.play(
      android: Android.alarm,
      ios: Ios.electronic,
      volume: 0.5,
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Simple Notification',
                body: 'Simple body'),
            actionButtons: [NotificationActionButton(key: '1', label: 'Oke')]);
      }
    });

    // RingtonePlayer.play(
    //   // alarmMeta: AlarmMeta(
    //   //   'com.example.alarmku.MainActivity',
    //   //   'ic_launcher',
    //   //   contentTitle: 'Alarm',
    //   //   contentText: 'Alarm is active',
    //   //   subText: 'Subtext',
    //   // ),
    //   android: Android.alarm,
    //   ios: Ios.electronic,
    //   loop: true, // Android only - API >= 28
    //   volume: 0.5, // Android only - API >= 28
    //   alarm: true, // Android only - all APIs
    // );

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  int alarmId = 1;
  alarmManager() async {
    await AndroidAlarmManager.periodic(
      const Duration(seconds: 5),
      // Ensure we have a unique alarm ID.

      1,
      callback,
      startAt: DateTime.now().add(const Duration(seconds: 5)),
      exact: true,
      wakeup: true,
    );
  }
}
