import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetClock extends CustomPainter {
  late DateTime dateTime;
  WidgetClock({required this.dateTime});

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    Paint fillBrush = Paint()..color = Get.theme.colorScheme.secondary;

    Paint centerFillBrush = Paint()..color = Get.theme.primaryColor;

    Paint hourLine = Paint()
      ..shader = RadialGradient(colors: [
        Get.theme.primaryColor,
        Get.theme.colorScheme.secondary,
      ]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    Paint minLine = Paint()
      ..shader = RadialGradient(colors: [
        Get.theme.primaryColor,
        Get.theme.colorScheme.secondary,
      ]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    Paint secLine = Paint()
      ..color = Get.theme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    Paint dashBrush = Paint()
      ..color = Get.theme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7;

    canvas.drawCircle(center, radius / 2 - 20, fillBrush);

    double hourX = centerX +
        40 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourY = centerX +
        40 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourX, hourY), hourLine);

    double minX = centerX + 60 * cos(dateTime.minute * 6 * pi / 180);
    double minY = centerX + 60 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minX, minY), minLine);

    double secX = centerX + 75 * cos(dateTime.second * 6 * pi / 180);
    double secY = centerX + 75 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(Offset(secX, secY), Offset(secX, secY), secLine);

    canvas.drawCircle(center, 10, centerFillBrush);

    var outerCircleRadius = radius / 2;
    for (double i = 0; i < 360; i += 30) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x1, y1), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
