import 'package:flutter/foundation.dart';

class Setting {
  String name = '';
  String value = '';

  Setting(this.name, this.value);

  Setting.fromMap(Map<String, dynamic?> val) {
    this.name = val['name'];
    this.value = val['value'];
  }
}
