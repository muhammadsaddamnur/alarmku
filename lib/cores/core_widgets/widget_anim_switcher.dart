import 'dart:async';
import 'package:flutter/material.dart';

class WidgetAnimSwitcher extends StatefulWidget {
  final Widget firstWidget, secondWidget;
  final Duration duration;

  const WidgetAnimSwitcher(
      {Key? key,
      required this.firstWidget,
      required this.secondWidget,
      this.duration = const Duration(seconds: 10)})
      : super(key: key);

  @override
  _WidgetAnimSwitcherState createState() => _WidgetAnimSwitcherState();
}

class _WidgetAnimSwitcherState extends State<WidgetAnimSwitcher>
    with SingleTickerProviderStateMixin {
  bool widgetKey = true;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(widget.duration, (Timer t) {
      setState(() {
        widgetKey = !widgetKey;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Widget firstWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      key: const ValueKey(true),
      child: widget.firstWidget,
    );
  }

  Widget secondWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      key: const ValueKey(false),
      child: widget.secondWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: widgetKey ? firstWidget() : secondWidget());
  }
}
