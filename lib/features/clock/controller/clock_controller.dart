import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:alarmku/cores/core_services/servcie_debounce.dart';
import 'package:alarmku/main.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ringtone_player/ringtone_player.dart';

abstract class ClockControllerAbstract {
  void initTimer();
  void cancelTimer();
  void horizontalDrag(DragUpdateDetails value);
  void verticalDrag(DragUpdateDetails value);
  void createAlarm();

  String getDateTimeNow();
}

class ClockController extends GetxController
    implements ClockControllerAbstract {
  ///ui isolate port
  ///
  static SendPort? uiSendPort;

  ///timer clock
  ///
  Rx<Timer> timer = Timer(const Duration(seconds: 0), () {}).obs;

  ///alarm timer clock
  ///
  Rx<Timer> alarmTimer = Timer(const Duration(seconds: 0), () {}).obs;

  ///datetime now
  ///
  Rx<DateTime> dateTime = DateTime.now().obs;

  ///alarm datetime
  ///
  Rx<DateTime> alarmDateTime = DateTime.now().obs;

  ///add/edit alarm
  ///
  RxBool isEdit = false.obs;

  ///init state
  ///
  @override
  void onInit() {
    timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      dateTime.value = DateTime.now();
    });

    ///init alarm timer
    ///
    initTimer();

    port.listen((_) async => print('oke'));

    ///notification listener
    ///
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      RingtonePlayer.stop();
      if (receivedNotification.buttonKeyPressed == '1') {
        print('wkwkwk');
      }
      Get.toNamed('/');
    });

    super.onInit();
  }

  ///dispose state
  ///
  @override
  void dispose() {
    timer.value.cancel();
    alarmTimer.value.cancel();
    super.dispose();
  }

  ///init alarm timer
  ///
  @override
  void initTimer() {
    alarmTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      alarmDateTime.value = DateTime.now();
    });
  }

  ///cancel alarm timer
  ///
  @override
  void cancelTimer() {
    if (alarmTimer.value.isActive) {
      alarmTimer.value.cancel();
    }
  }

  ///get realtime datetime
  ///
  @override
  String getDateTimeNow() {
    return DateFormat('HH:mm:ss').format(dateTime.value).toString();
  }

  ///horizontal drag on clock
  ///
  @override
  void horizontalDrag(DragUpdateDetails value) {
    cancelTimer();
    print('horizontal :' + value.toString());
    if (value.delta.dx != 0.0) {
      debugPrint(value.delta.dx.toString());

      if (value.delta.dx > 0) {
        ServiceDebounce.call(
            function: () async {
              alarmDateTime.value =
                  alarmDateTime.value.add(const Duration(minutes: 1));

              alarmDateTime.value = DateTime(
                  dateTime.value.year,
                  dateTime.value.month,
                  dateTime.value.day,
                  alarmDateTime.value.hour,
                  alarmDateTime.value.minute,
                  alarmDateTime.value.second,
                  alarmDateTime.value.millisecond,
                  alarmDateTime.value.microsecond);
            },
            duration: const Duration(milliseconds: 10));
      } else {
        ServiceDebounce.call(
            function: () async {
              alarmDateTime.value =
                  alarmDateTime.value.subtract(const Duration(minutes: 1));

              alarmDateTime.value = DateTime(
                  dateTime.value.year,
                  dateTime.value.month,
                  dateTime.value.day,
                  alarmDateTime.value.hour,
                  alarmDateTime.value.minute,
                  alarmDateTime.value.second,
                  alarmDateTime.value.millisecond,
                  alarmDateTime.value.microsecond);
            },
            duration: const Duration(milliseconds: 10));
      }
    }
  }

  ///vertical drag on clock
  ///
  @override
  void verticalDrag(DragUpdateDetails value) {
    cancelTimer();
    print('vertical :' + value.toString());

    if (value.delta.dy != 0.0) {
      debugPrint(value.delta.dy.toString());

      if (value.delta.dy > 0) {
        ServiceDebounce.call(function: () async {
          alarmDateTime.value =
              alarmDateTime.value.add(const Duration(hours: 1));

          alarmDateTime.value = DateTime(
              dateTime.value.year,
              dateTime.value.month,
              dateTime.value.day,
              alarmDateTime.value.hour,
              alarmDateTime.value.minute,
              alarmDateTime.value.second,
              alarmDateTime.value.millisecond,
              alarmDateTime.value.microsecond);
        });
      } else {
        ServiceDebounce.call(function: () async {
          alarmDateTime.value =
              alarmDateTime.value.subtract(const Duration(hours: 1));

          alarmDateTime.value = DateTime(
              dateTime.value.year,
              dateTime.value.month,
              dateTime.value.day,
              alarmDateTime.value.hour,
              alarmDateTime.value.minute,
              alarmDateTime.value.second,
              alarmDateTime.value.millisecond,
              alarmDateTime.value.microsecond);
        });
      }
    }
  }

  ///create alarm
  ///
  @override
  void createAlarm() async {
    var test = DateFormat("dd/MM/yyyy HH:mm:ss").parse(
        "${dateTime.value.day}/${dateTime.value.month}/${dateTime.value.year} 00:15:00");

    await AndroidAlarmManager.periodic(
      const Duration(seconds: 10),
      1,
      callbackAlarm,
      // startAt: DateTime.now().add(const Duration(seconds: 5)),
      // startAt: test,
      exact: true,
      wakeup: true,
    );
  }

  ///callback alarm
  ///
  static Future<void> callbackAlarm() async {
    print('Alarm fired!');

    RingtonePlayer.play(
      android: Android.alarm,
      ios: Ios.electronic,
      volume: 0.5,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
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
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }
}
