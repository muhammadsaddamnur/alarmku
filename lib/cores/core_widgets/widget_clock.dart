import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetClock extends CustomPainter {
  late DateTime dateTime;
  double width, height;
  bool isSetAlarm, isAlarmHand;
  WidgetClock(
      {required this.dateTime,
      required this.width,
      required this.height,
      this.isSetAlarm = false,
      required this.isAlarmHand});

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = width / 2;
    double centerY = height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    Paint fillBrush = Paint()
      ..color = isSetAlarm
          ? Get.theme.colorScheme.secondary.withOpacity(0.3)
          : Get.theme.colorScheme.secondary;

    Paint centerFillBrush = Paint()
      ..color = isSetAlarm
          ? Get.theme.primaryColor.withOpacity(0.3)
          : Get.theme.primaryColor;

    Paint hourLine = Paint()
      ..shader = RadialGradient(colors: [
        isSetAlarm
            ? Get.theme.primaryColor.withOpacity(0.3)
            : Get.theme.primaryColor,
        isSetAlarm
            ? Get.theme.colorScheme.secondary.withOpacity(0.3)
            : Get.theme.colorScheme.secondary,
      ]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    Paint minLine = Paint()
      ..shader = RadialGradient(colors: [
        isSetAlarm
            ? Get.theme.primaryColor.withOpacity(0.3)
            : Get.theme.primaryColor,
        isSetAlarm
            ? Get.theme.colorScheme.secondary.withOpacity(0.3)
            : Get.theme.colorScheme.secondary,
      ]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    Paint secLine = Paint()
      ..color = isSetAlarm
          ? Get.theme.primaryColor.withOpacity(0.3)
          : Get.theme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    Paint dashBrush = Paint()
      ..color = isSetAlarm
          ? Get.theme.primaryColor.withOpacity(0.3)
          : Get.theme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7;

    if (!isAlarmHand) canvas.drawCircle(center, radius / 2 - 20, fillBrush);

    double hourX = centerX +
        40 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourY = centerX +
        40 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourX, hourY), hourLine);

    double minX = centerX + 60 * cos(dateTime.minute * 6 * pi / 180);
    double minY = centerX + 60 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minX, minY), minLine);

    double secX = centerX + 83 * cos(dateTime.second * 6 * pi / 180);
    double secY = centerX + 83 * sin(dateTime.second * 6 * pi / 180);
    if (!isAlarmHand) canvas.drawCircle(Offset(secX, secY), 8, secLine);

    canvas.drawCircle(center, 10, centerFillBrush);

    var outerCircleRadius = radius / 1.5;
    for (double i = 0; i < 360; i += 30) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);
      if (!isAlarmHand) {
        canvas.drawLine(Offset(x1, y1), Offset(x1, y1), dashBrush);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
