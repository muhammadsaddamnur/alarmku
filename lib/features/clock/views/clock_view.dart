import 'dart:ui';
import 'package:alarmku/cores/core_services/service_local_storage.dart';
import 'package:alarmku/cores/core_widgets/widget_anim_expanded.dart';
import 'package:alarmku/cores/core_widgets/widget_anim_switcher.dart';
import 'package:alarmku/cores/core_widgets/widget_card_setting.dart';
import 'package:alarmku/cores/core_widgets/widget_clock.dart';
import 'package:alarmku/cores/core_widgets/widget_list_alarm.dart';
import 'package:alarmku/features/clock/controller/clock_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClockView extends StatefulWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  final clockController = Get.put(ClockController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: Get.width,
                child: WidgetAnimSwitcher(
                    firstWidget: Center(
                      child: Text(
                        'Hallo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.colorScheme.primary),
                      ),
                    ),
                    secondWidget: Center(
                      child: Text(
                        DateFormat('dd-MM-yyyy')
                            .format(DateTime.now())
                            .toString()
                            .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.colorScheme.primary),
                      ),
                    )),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                clockController.getDateTimeNow(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.primary),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      if (clockController.currentAlarmValue.value.isEmpty) {
                        clockController.isEdit.value =
                            !clockController.isEdit.value;
                        if (!clockController.isEdit.value) {
                          clockController.initTimer();
                        } else {
                          clockController.cancelTimer();
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Hapus alarm sebelumnya terlebih dulu');
                      }
                    },
                    onVerticalDragUpdate: !clockController.isEdit.value
                        ? null
                        : (value) {
                            clockController.verticalDrag(value);
                          },
                    onHorizontalDragUpdate: !clockController.isEdit.value
                        ? null
                        : (value) {
                            clockController.horizontalDrag(value);
                          },
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        children: [
                          Obx(
                            () => RotatedBox(
                              quarterTurns: 3,
                              child: CustomPaint(
                                child: Container(),
                                painter: WidgetClock(
                                    height: 250,
                                    width: 250,
                                    isAlarmHand: false,
                                    isSetAlarm: clockController.isEdit.value,
                                    dateTime: clockController.dateTime.value),
                              ),
                            ),
                          ),
                          Obx(
                            () => clockController.isEdit.value
                                ? RotatedBox(
                                    quarterTurns: 3,
                                    child: CustomPaint(
                                      child: Container(),
                                      painter: WidgetClock(
                                          height: 250,
                                          width: 250,
                                          isAlarmHand: true,
                                          dateTime: clockController
                                              .alarmDateTime.value),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                return clockController.currentAlarmValue.value == ''
                    ? Text(
                        'Tap dua kali untuk menyetel alarm',
                        textAlign: TextAlign.center,
                        style: Get.textTheme.caption,
                      )
                    : WidgetListAlarm(
                        datetime: clockController.currentAlarmValue.value,
                        onRemove: () {
                          clockController.removeAlarm();
                        },
                      );
              }),
            ),
            SliverToBoxAdapter(
                child: WidgetAnimExpanded(
                    expand: clockController.isEdit.value,
                    child: WidgetCardSetting(
                      cardOptions: CardOptions(
                          dateTime: clockController.alarmDateTime.value,
                          onTapCancel: () {
                            clockController.isEdit.value = false;
                          },
                          onTapSave: () {
                            clockController.createAlarm();
                            clockController.isEdit.value = false;
                          }),
                    ))),
            SliverToBoxAdapter(
              child: Obx(
                () => clockController.dataAlarm.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 200, child: clockController.viewGraph()),
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(
                () => clockController.dataAlarm.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              ServiceLocalStorage().removeDataAlarm();
                              clockController.dataAlarm.clear();
                            },
                            child: const Text('Hapus')),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
