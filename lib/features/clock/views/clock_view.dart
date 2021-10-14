import 'dart:math';
import 'dart:ui';
import 'package:alarmku/cores/core_widgets/widget_anim_expanded.dart';
import 'package:alarmku/cores/core_widgets/widget_anim_switcher.dart';
import 'package:alarmku/cores/core_widgets/widget_card_setting.dart';
import 'package:alarmku/cores/core_widgets/widget_clock.dart';
import 'package:alarmku/cores/core_widgets/widget_list_alarm.dart';
import 'package:alarmku/features/clock/controller/clock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              child: Container(
                width: Get.width,
                child: WidgetAnimSwitcher(
                    firstWidget: Center(
                      child: Text(
                        'Selamat Siang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.colorScheme.primary),
                      ),
                    ),
                    secondWidget: Center(
                      child: Text(
                        'Hari ini',
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
                      clockController.isEdit.value =
                          !clockController.isEdit.value;
                      if (!clockController.isEdit.value) {
                        clockController.initTimer();
                      } else {
                        clockController.cancelTimer();
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
                                : SizedBox(),
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
                return Text('${clockController.alarmDateTime.value}');
              }),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                Duration dif = clockController.dateTime.value
                    .difference(clockController.alarmDateTime.value);
                return Text('${dif.inHours} jam '
                    '${dif.inMinutes} menit');
              }),
            ),
            SliverToBoxAdapter(
                child: WidgetAnimExpanded(
                    expand: clockController.isEdit.value,
                    child: WidgetCardSetting(
                      cardOptions: CardOptions(
                          dateTime: clockController.alarmDateTime.value,
                          onTapSave: () {
                            clockController.createAlarm();
                          }),
                    ))),
            SliverToBoxAdapter(
              child: Center(
                  child: Text(
                'Belum ada alarm',
                style: Get.textTheme.caption,
              )),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return WidgetListAlarm();
              }, childCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
