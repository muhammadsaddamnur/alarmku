import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetListAlarm extends StatelessWidget {
  const WidgetListAlarm({Key? key}) : super(key: key);

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
                        '09:09',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 40, color: Get.theme.colorScheme.primary),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete,
                              color: Get.theme.colorScheme.error,
                            )),
                        Switch(value: false, onChanged: (x) {})
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        'Senin, Selasa, Rabu',
                        textAlign: TextAlign.start,
                        style: Get.textTheme.caption,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        ' - Catatan',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: Get.textTheme.caption!.fontSize,
                            color: Get.textTheme.caption!.color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
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
