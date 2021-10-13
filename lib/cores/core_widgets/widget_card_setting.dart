import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CardOptions {
  DateTime dateTime;
  CardOptions({required this.dateTime});
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
              Divider(
                height: 50,
                thickness: 0.5,
              ),
              Text(
                'Ulangi Setiap',
                style: TextStyle(
                    fontSize: 14, color: Get.textTheme.caption!.color),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  'Senin',
                  'Selasa',
                  'Rabu',
                  'Kamis',
                  'Jumat',
                  'Sabtu',
                  'Minggu',
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(
                            right: 3,
                          ),
                          child: Chip(
                            label: Text(
                              e,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Get.theme.colorScheme.primary),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0.5,
                          ),
                        ))
                    .toList(),
              ),
              Divider(
                height: 50,
                thickness: 0.5,
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Tap disini untuk menambah catatan',
                ),
              ),
              SizedBox(
                height: 30,
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
                        onPressed: () {},
                        child: Text('Batalkan')),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: () {},
                        child: Text('Simpan')),
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
