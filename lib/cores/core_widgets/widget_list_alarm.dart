import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetListAlarm extends StatelessWidget {
  final String? datetime;
  final Function()? onRemove;
  const WidgetListAlarm({
    Key? key,
    this.datetime,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$datetime',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 40, color: Get.theme.colorScheme.primary),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: onRemove,
                            icon: Icon(
                              Icons.delete,
                              color: Get.theme.colorScheme.error,
                            )),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Divider(
              height: 0,
              thickness: 0.5,
            ),
          )
        ],
      ),
    );
  }
}
