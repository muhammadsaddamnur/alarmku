import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ServiceLocalStorage {
  static final ServiceLocalStorage _serviceLocalStorage =
      ServiceLocalStorage._internal();

  factory ServiceLocalStorage() {
    return _serviceLocalStorage;
  }

  ServiceLocalStorage._internal();

  final String _hiveBox = 'v1';

  ///init method for hive
  ///
  Future init() async {
    if (!kIsWeb) {
      // var path = Directory.current.path;
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
    }
  }

  ///get data from hive, return data is dynamic
  ///
  get({bool isJson = false, required String key}) async {
    var box = await Hive.openBox(_hiveBox);
    if (isJson) {
      return json.decode(box.get(key) ?? [].toString());
    } else {
      return box.get(key) ?? '';
    }
  }

  ///you can put any data, data type according to the input
  ///
  put({required value, bool isJson = false, required String key}) async {
    var box = await Hive.openBox(_hiveBox);
    if (isJson) {
      box.put(key, json.encode(value));
    } else {
      box.put(key, value);
    }
  }

  ///delete method
  ///
  delete({required String key}) async {
    var box = await Hive.openBox(_hiveBox);
    box.delete(key);
  }

  saveAlarm(value) async {
    await put(key: 'alarm', value: [value], isJson: true);
  }

  getAlarm() async {
    List result = await get(key: 'alarm', isJson: true);
    return result.isEmpty ? [] : result;
  }

  removeAlarm() async {
    await delete(key: 'alarm');
  }

  saveDataAlarm(value) async {
    List result = await getDataAlarm();
    result.add(value);
    await put(key: 'dataAlarm', value: result, isJson: true);
  }

  getDataAlarm() async {
    List result = await get(key: 'dataAlarm', isJson: true);
    return result.isEmpty ? [] : result;
  }

  removeLastDataAlarm() async {
    List result = await getDataAlarm();
    if (result.length % 2 == 1) {
      result.removeLast();
    }
    await put(key: 'dataAlarm', value: result, isJson: true);
  }

  removeDataAlarm() async {
    await delete(key: 'dataAlarm');
  }
}
