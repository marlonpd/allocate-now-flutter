import 'dart:convert';
import 'dart:developer';

import 'package:allocate_now/helpers/db_helper.dart';
import 'package:allocate_now/models/setting.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class Settings with ChangeNotifier {
  List<Setting> _settings = [];
  //String currency = '';
  static const CURRENCY = 'currency';
  static const EMAIL = 'email';
  Future<void> fetchAndSetSettings() async {
    var dataList = await DBHelper.getData('settings');

    _settings =
        dataList.map((item) => Setting(item['name'], item['value'])).toList();

    // print('dataList');
    // print(_settings);
    // print(json.encode(dataList));

    notifyListeners();
  }

  String findByName(String name) {
    var setting = _settings.firstWhereOrNull((s) => s.name == name);

    if (setting == null) {
      return '';
    }

    return setting.value;
  }

  String get currencySymbol {
    var setting = findByName(CURRENCY);
    // _settings.firstWhereOrNull((s) => s.name == CURRENCY);

    // if (setting == null) {
    //   return '\$';
    // }

    var splitted = setting.split('_');

    if (splitted.length > 0) {
      return splitted[1];
    }

    return '\$';
  }

  void updateSettings(String name, String value) async {
    final ndx = _settings.indexWhere((item) => item.name == name);

    if (ndx >= 0) {
      _settings[ndx].value = value;
    } else {
      var _newSetting = new Setting(name, value);
      _settings.add(_newSetting);
    }
    notifyListeners();

    await DBHelper.updateSettings(name, value);
  }

  List<Setting> get settings {
    return [..._settings];
  }
}
