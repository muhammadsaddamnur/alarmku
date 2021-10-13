import 'dart:async';

import 'package:alarmku/cores/core_services/servcie_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

abstract class ClockControllerAbstract {
  void initTimer();
  void cancelTimer();
  void horizontalDrag(DragUpdateDetails value);
  void verticalDrag(DragUpdateDetails value);

  String getDateTimeNow();
}

class ClockController extends GetxController
    implements ClockControllerAbstract {
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
            },
            duration: const Duration(milliseconds: 10));
      } else {
        ServiceDebounce.call(
            function: () async {
              alarmDateTime.value =
                  alarmDateTime.value.subtract(const Duration(minutes: 1));
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
        });
      } else {
        ServiceDebounce.call(function: () async {
          alarmDateTime.value =
              alarmDateTime.value.subtract(const Duration(hours: 1));
        });
      }
    }
  }
}
