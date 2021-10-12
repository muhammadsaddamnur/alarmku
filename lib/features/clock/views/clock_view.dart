import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:alarmku/cores/core_services/servcie_debounce.dart';
import 'package:alarmku/cores/core_services/service_local_notification.dart';
import 'package:alarmku/cores/core_widgets/widget_anim_switcher.dart';
import 'package:alarmku/cores/core_widgets/widget_clock.dart';
import 'package:alarmku/features/clock/controller/clock_controller.dart';
import 'package:alarmku/main.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ringtone_player/ringtone_player.dart';

class ClockView extends StatefulWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  static SendPort? uiSendPort;

  static Future<void> callback() async {
    print('Alarm fired!');
    RingtonePlayer.play(
      alarmMeta: AlarmMeta(
        'com.example.alarmku.MainActivity',
        'ic_launcher',
        contentTitle: 'Alarm',
        contentText: 'Alarm is active',
        subText: 'Subtext',
      ),
      android: Android.alarm,
      ios: Ios.electronic,
      loop: true, // Android only - API >= 28
      volume: 0.1, // Android only - API >= 28
      alarm: true, // Android only - all APIs
    );

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  int alarmId = 1;
  final clockController = Get.put(ClockController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH:mm a').format(DateTime.now()).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(
                  width: Get.width,
                  child: const WidgetAnimSwitcher(
                    firstWidget: Text(
                      'Hallo Jakarta',
                      textAlign: TextAlign.center,
                    ),
                    secondWidget: Text('WKWKW'),
                  ),
                ),
                GestureDetector(
                  onVerticalDragUpdate: (value) {
                    if (clockController.timer.value.isActive) {
                      clockController.timer.value.cancel();
                    }
                    if (value.delta.dy != 0.0) {
                      debugPrint(value.delta.dy.toString());

                      if (value.delta.dy > 0) {
                        ServiceDebounce.call(function: () async {
                          clockController.dateTime.value = clockController
                              .dateTime.value
                              .add(const Duration(hours: 1));
                          clockController.hourController.value.animateTo(
                              50 *
                                  (clockController.dateTime.value.hour == 00
                                          ? 24
                                          : clockController.dateTime.value.hour)
                                      .toDouble(),
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn);
                        });
                      } else {
                        ServiceDebounce.call(function: () async {
                          clockController.dateTime.value = clockController
                              .dateTime.value
                              .subtract(const Duration(hours: 1));
                          clockController.hourController.value.animateTo(
                              50 *
                                  (clockController.dateTime.value.hour == 00
                                          ? 24
                                          : clockController.dateTime.value.hour)
                                      .toDouble(),
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn);
                        });
                      }
                    }
                  },
                  onHorizontalDragUpdate: (value) {
                    if (clockController.timer.value.isActive) {
                      clockController.timer.value.cancel();
                    }
                    if (value.delta.dx != 0.0) {
                      debugPrint(value.delta.dx.toString());

                      if (value.delta.dx > 0) {
                        ServiceDebounce.call(
                            function: () async {
                              clockController.dateTime.value = clockController
                                  .dateTime.value
                                  .add(const Duration(minutes: 1));
                            },
                            duration: Duration(milliseconds: 10));
                      } else {
                        ServiceDebounce.call(
                            function: () async {
                              clockController.dateTime.value = clockController
                                  .dateTime.value
                                  .subtract(const Duration(minutes: 1));
                            },
                            duration: Duration(milliseconds: 10));
                      }
                    }
                  },
                  child: SizedBox(
                    width: Get.width,
                    height: Get.width,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: CustomPaint(
                        painter: WidgetClock(
                            dateTime: clockController.dateTime.value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ListWheelScrollView(
                          controller: clockController.hourController.value,
                          itemExtent: 50,
                          onSelectedItemChanged: (int value) {},
                          physics: FixedExtentScrollPhysics(),
                          children: List.generate(24, (index) {
                            return Center(
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Text(clockController.dateTime.value.toString()),
                Text(
                  '${clockController.hourController.value.hasClients ? clockController.hourController.value.selectedItem : ''}',
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          clockController.timer.value = Timer.periodic(
                              const Duration(seconds: 1), (timer) {
                            clockController.dateTime.value = DateTime.now();
                          });
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        child: const Text(
                          'Alarm Manager',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await AndroidAlarmManager.periodic(
                            const Duration(seconds: 5),
                            // Ensure we have a unique alarm ID.

                            Random().nextInt(pow(2, 31).toInt()),
                            callback,
                            startAt:
                                DateTime.now().add(const Duration(seconds: 5)),
                            exact: true,
                            wakeup: true,
                          );
                          // AndroidAlarmManager.periodic(
                          //     Duration(seconds: 4), alarmId, fireAlarm);
                          // ServiceLocalNotification().pushSchedule(
                          //     id: 1,
                          //     dateTime:
                          //         DateTime.now().add(Duration(seconds: 5)));
                        }),
                  ],
                ),
                ElevatedButton(
                    child: const Text(
                      'data',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // RingtonePlayer.stop();

                      RingtonePlayer.play(
                        alarmMeta: AlarmMeta(
                          'com.example.alarmku.MainActivity',
                          'ic_alarm_notification',
                          contentTitle: 'Alarm',
                          contentText: 'Alarm is active',
                          subText: 'Subtext',
                        ),
                        android: Android.ringtone,
                        ios: Ios.electronic,
                        loop: true, // Android only - API >= 28
                        volume: 0.1, // Android only - API >= 28
                        alarm: true, // Android only - all APIs
                      );

                      // RingtonePlayer.play(
                      //   android: Android.ringtone,
                      //   ios: Ios.electronic,
                      //   loop: true,
                      //   volume: 1.0,
                      // );
                    }),
                ElevatedButton(
                    child: const Text(
                      'data',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      RingtonePlayer.stop();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
