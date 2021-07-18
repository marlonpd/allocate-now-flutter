import 'package:flutter/foundation.dart';

class Budget {
  String id = '';
  String name = '';
  double amount = 0;
  DateTime createdAt = DateTime.now();
  double totalAmount = 0;

  Budget(@required this.id, @required this.name, @required this.amount,
      @required this.createdAt, @required this.totalAmount);

  Budget.fromMap(Map<String, dynamic?> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.amount = map['amount'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.totalAmount = map['totalAmount'];
  }
}
