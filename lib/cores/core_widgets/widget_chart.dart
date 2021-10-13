import 'package:flutter/material.dart';

class Score {
  late double? value;
  late DateTime? time;
  Score({this.value, this.time});
}

const WeekDays = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

class WidgetChart extends StatefulWidget {
  final List<Score>? scores;
  const WidgetChart({Key? key, this.scores}) : super(key: key);

  @override
  _WidgetChartState createState() => _WidgetChartState();
}

class _WidgetChartState extends State<WidgetChart> {
  late double _min, _max;
  late List<double> _y;
  late List<String> _x;

  @override
  void initState() {
    super.initState();
    var min = double.maxFinite;
    var max = -double.maxFinite;
    widget.scores!.forEach((p) {
      min = (min > p.value! ? p.value : min)!;
      max = (max < p.value! ? p.value : max)!;
    });

    setState(() {
      _min = min;
      _max = max;
      _y = widget.scores!.map((p) => p.value!.toDouble()).toList();
      _x = widget.scores!
          .map((p) => "${WeekDays[p.time!.weekday]}\n${p.time!.day}")
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        child: Container(),
        painter: ChartPainter(_x, _y, _min, _max),
      ),
    );
  }
}

///painter
///
class ChartPainter extends CustomPainter {
  final List<String> x;
  final List<double> y;
  final double min, max;

  ChartPainter(this.x, this.y, this.min, this.max);

  final Color backgroundColor = Colors.black;

  final linePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final yLabelStyle = TextStyle(color: Colors.white, fontSize: 14);
  final xLabelStyle =
      TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);

  static double border = 10.0;
  static double radius = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaintFill = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final clipRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(clipRect);
    canvas.drawPaint(Paint()..color = Colors.black);

    final drawableHeight = size.height - 2.0 * border;
    final drawableWidth = size.width - 2.0 * border;
    final hd = drawableHeight / 5;
    final wd = drawableWidth / this.x.length;

    final height = hd * 3.0;
    final width = drawableWidth;

    if (height <= 0 || width <= 0) return;
    if (max - min < 1.0e-6) return;

    final hr = height / (max - min);

    final left = border;
    final top = border;
    final c = Offset(left + wd / 2, top + height / 2);

    ///draw line
    // _drawOutline(canvas, c, wd, height);

    final points = _computePoints(c, wd, height, hr);
    final path = _computePath(points);
    final labels = _computeLabel();

    ///draw line
    ///
    canvas.drawPath(path, linePaint);

    _drawDataPoint(canvas, points, dotPaintFill);
    _drawYLabels(canvas, labels, points, wd, top);

    final c1 = Offset(c.dx, top + 4.5 * hd);
    _drawXLabels(canvas, c1, wd);
  }

  void _drawXLabels(Canvas canvas, Offset c, double wd) {
    x.forEach((xp) {
      drawTextCentered(canvas, c, xp, xLabelStyle, wd);
      c += Offset(wd, 0);
    });
  }

  void _drawYLabels(Canvas canvas, List<String> labels, List<Offset> points,
      double wd, double top) {
    var i = 0;
    labels.forEach((label) {
      final dp = points[i];
      final dy = (dp.dy - 15) < top ? 15.0 : -15.0;
      final ly = dp + Offset(0, dy);
      drawTextCentered(canvas, ly, label, yLabelStyle, wd);
      i++;
    });
  }

  void _drawDataPoint(Canvas canvas, List<Offset> points, Paint dotPaintFill) {
    points.forEach((dp) {
      canvas.drawCircle(dp, radius, dotPaintFill);
      canvas.drawCircle(dp, radius, linePaint);
    });
  }

  _computePath(List<Offset> points) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path;
  }

  List<Offset> _computePoints(
      Offset c, double width, double height, double hr) {
    List<Offset> points = [];
    y.forEach((yp) {
      final yy = height - (yp - min) * hr;
      final dp = Offset(c.dx, c.dy - height / 2 + yy);
      points.add(dp);
      c += Offset(width, 0);
    });
    return points;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  final Paint outlinePaint = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..color = Colors.white;

  void _drawOutline(Canvas canvas, Offset c, double width, double height) {
    y.forEach((p) {
      final rect = Rect.fromCenter(center: c, width: width, height: height);
      canvas.drawRect(rect, outlinePaint);
      c += Offset(width, 0);
    });
  }

  List<String> _computeLabel() {
    return y.map((yp) => "${yp.toStringAsFixed(1)}").toList();
  }

  measureText(String s, TextStyle style, double maxWidth, TextAlign align) {
    final span = TextSpan(text: s, style: style);
    final tp = TextPainter(
        text: span, textAlign: align, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  void drawTextCentered(
      Canvas canvas, Offset c, String text, TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final offset = c + Offset(-tp.width / 2, -tp.height / 2);
    tp.paint(canvas, offset);
    return tp.size;
  }
}
