import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:alarmku/cores/core_services/servcie_debounce.dart';
import 'package:alarmku/cores/core_services/service_local_storage.dart';
import 'package:alarmku/main.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fl_chart/fl_chart.dart';
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
  void removeAlarm();
  void saveCurrentAlarm(
      String? title, String? subtitle, Duration? duration, DateTime? schedule);
  void getDataAlarm();
  void saveDataAlarm(DateTime? datetime);

  String getDateTimeNow();
  Future<String> getCurrentAlarm();
  Widget viewGraph();
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

  ///current alarm value
  ///
  RxString currentAlarmValue = ''.obs;

  RxList<BarChartGroupData> dataAlarm = <BarChartGroupData>[].obs;

  ///init state
  ///
  @override
  void onInit() async {
    currentAlarmValue.value = await getCurrentAlarm();

    timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      dateTime.value = DateTime.now();
    });

    ///init alarm timer
    ///
    initTimer();

    port.listen((_) async => debugPrint('oke'));

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed == false) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    ///notification listener
    ///
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      List result = await ServiceLocalStorage().getDataAlarm();

      if (result.length % 2 == 1) {
        DateTime v = DateTime.now();
        saveDataAlarm(v);
      }
      getDataAlarm();
    });

    getDataAlarm();

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

  ///save current alarm
  ///
  @override
  void saveCurrentAlarm(String? title, String? subtitle, Duration? duration,
      DateTime? schedule) async {
    try {
      await ServiceLocalStorage().saveAlarm({
        'datetime': schedule.toString(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///get current alarm
  ///
  @override
  Future<String> getCurrentAlarm() async {
    List result = await ServiceLocalStorage().getAlarm();
    return result.isEmpty
        ? ''
        : DateFormat('HH:mm')
            .format(DateTime.parse(result.first['datetime']))
            .toString();
  }

  ///save current data alarm
  ///
  @override
  void saveDataAlarm(DateTime? datetime) async {
    try {
      await ServiceLocalStorage().saveDataAlarm({
        'datetime': datetime.toString(),
      });
      getDataAlarm();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///get current data alarm
  ///
  @override
  void getDataAlarm() async {
    List result = await ServiceLocalStorage().getDataAlarm();
    dataAlarm.clear();

    int looping = result.length - (result.length % 2);
    List u = [];
    for (var i = 0; i < result.length; i++) {
      u.add(result[i]['datetime']);
    }
    debugPrint(u.toString());

    for (var i = 0; i < looping; i = i + 2) {
      DateTime data1 = DateTime.parse(result[i]['datetime']);
      DateTime data2 = DateTime.parse(result[i + 1]['datetime']);
      final difference = data2.difference(data1);

      dataAlarm.add(
        BarChartGroupData(x: (i / 2 + 1).round(), barRods: [
          BarChartRodData(
              y: difference.inSeconds.toDouble(),
              colors: [const Color(0xff43dde6), const Color(0xff43dde6)]),
        ]),
      );
    }
    update();
  }

  ///horizontal drag on clock
  ///
  @override
  void horizontalDrag(DragUpdateDetails value) {
    cancelTimer();
    // debugPrint('horizontal :' + value.toString());
    if (value.delta.dx != 0.0) {
      // debugPrint(value.delta.dx.toString());

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
    // debugPrint('vertical :' + value.toString());

    if (value.delta.dy != 0.0) {
      // debugPrint(value.delta.dy.toString());

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

  ///remove alarm
  ///
  @override
  void removeAlarm() async {
    try {
      AndroidAlarmManager.cancel(1);
      ServiceLocalStorage().removeAlarm();
      ServiceLocalStorage().removeLastDataAlarm();
      currentAlarmValue.value = await getCurrentAlarm();
      getDataAlarm();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///create alarm
  ///
  @override
  void createAlarm() async {
    saveCurrentAlarm('Ini alarm gua', 'iya ini', const Duration(seconds: 0),
        alarmDateTime.value);
    alarmDateTime.value = DateTime(
        dateTime.value.year,
        dateTime.value.month,
        dateTime.value.day,
        alarmDateTime.value.hour,
        alarmDateTime.value.minute,
        0,
        0,
        0);
    saveDataAlarm(alarmDateTime.value);

    currentAlarmValue.value = await getCurrentAlarm();
    setAlarm(alarmDateTime.value);
  }

  ///set alarm
  ///
  static setAlarm(DateTime datetime) async {
    await AndroidAlarmManager.periodic(
      const Duration(seconds: 10),
      1,
      callbackAlarm,
      startAt: DateFormat("dd/MM/yyyy HH:mm:ss").parse(
          "${datetime.day}/${datetime.month}/${datetime.year} ${datetime.hour}:${datetime.minute}:00"),
      exact: true,
      wakeup: true,
    );
  }

  ///callback alarm
  ///
  static Future<void> callbackAlarm() async {
    RingtonePlayer.play(
      android: Android.alarm,
      ios: Ios.electronic,
      volume: 0.5,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed == false) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Simple Notification',
                body: 'Simple body'),
            actionButtons: []);
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    RingtonePlayer.stop();
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  ///view of graph
  ///
  @override
  Widget viewGraph() {
    return Obx(() {
      debugPrint(dataAlarm.toList().toString());
      return BarChart(BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return '${value.toInt()}';
            },
          ),
          rightTitles: SideTitles(
            interval: 5,
            showTitles: false,
          ),
          leftTitles: SideTitles(
            interval: 10,
            showTitles: true,
          ),
        ),
        borderData:
            FlBorderData(border: Border.all(color: Colors.white, width: 0.5)),
        alignment: BarChartAlignment.spaceEvenly,
        maxY: 50,
        barGroups: dataAlarm,
      ));
    });
  }
}
