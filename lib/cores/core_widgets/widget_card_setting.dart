import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CardOptions {
  DateTime dateTime;
  void Function()? onTapSave, onTapCancel;
  CardOptions(
      {required this.dateTime,
      required this.onTapSave,
      required this.onTapCancel});
}

class WidgetCardSetting extends StatelessWidget {
  final CardOptions cardOptions;

  const WidgetCardSetting({Key? key, required this.cardOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Get.theme.colorScheme.primary, width: 0.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Setel alarm',
                style: TextStyle(
                    fontSize: 14, color: Get.textTheme.caption!.color),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      DateFormat('HH').format(cardOptions.dateTime).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 50, color: Get.theme.colorScheme.primary),
                    ),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                        fontSize: 50, color: Get.theme.colorScheme.primary),
                  ),
                  Flexible(
                    child: Text(
                      DateFormat('mm').format(cardOptions.dateTime).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 50, color: Get.theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Get.theme.colorScheme.error),
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: cardOptions.onTapCancel,
                        child: const Text('Batalkan')),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: cardOptions.onTapSave,
                        child: const Text('Simpan')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
