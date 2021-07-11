import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/currency.dart';
import 'dart:developer';

class Currencies with ChangeNotifier {
  List<dynamic> _items = [];
  dynamic t = 1;

  Future<void> getCurrencies() async {
    var jsonText = await rootBundle.loadString('assets/json/currencies.json');

    try {
      (json.decode(jsonText)).forEach((entitlement) {
        log(entitlement.toString());
      });
      // (json.decode(jsonText)).map((c) {
      //   log(c);
      //   //Currency.fromMap(c) as Currency
      //   return t;
      // }).toList();
    } catch (e) {
      print(e);
    }
    _items = [
      {"symbol": "\$", "name": "US - Dollar"},
      {"symbol": "P", "name": "PH - Peso"},
    ];
    notifyListeners();
  }

  List<dynamic> get items {
    return [..._items];
  }

  Future<void> saveSettings(String name, String value) async {}
}
