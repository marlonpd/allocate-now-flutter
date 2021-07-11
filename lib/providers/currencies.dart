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

    //log(jsonText);

    try {
      _items = (json.decode(jsonText)).map((c) {
        // log(c.toString());
        return Currency(c['symbol'], c['code']) as Currency;
      }).toList();
      log('Fetching currencies');
      log(_items.toString());
    } catch (e) {
      print('watch the pak');
      print(e);
    }
    // _items = [
    //   Currency("\$", "US - Dollar"),
    //   Currency("P", "PH - Peso"),
    // ];
    notifyListeners();
  }

  List<dynamic> get items {
    return [..._items];
  }

  Future<void> saveSettings(String name, String value) async {}
}
