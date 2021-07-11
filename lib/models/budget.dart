import 'package:flutter/foundation.dart';

class Budget {
  String id = '';
  String name = '';
  double amount = 0;
  DateTime createdAt = DateTime.now();

  Budget(@required this.id, @required this.name, @required this.amount,
      @required this.createdAt);

  Budget.fromMap(Map<String, dynamic?> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.amount = map['amount'];
    this.createdAt = DateTime.parse(map['createdAt']);
  }
}
