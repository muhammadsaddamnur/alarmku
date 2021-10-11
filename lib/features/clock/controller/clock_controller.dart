import 'dart:async';

import 'package:alarmku/cores/core_services/servcie_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  }
}
