import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../helpers/db_helper.dart';
import '../models/budget.dart';

class Budgets with ChangeNotifier {
  List<Budget> _items = [];

  String _lastAddedBudgetId = '';

  List<Budget> get items {
    return [..._items];
  }

  String get lastAddedBudgetId {
    return _lastAddedBudgetId;
  }

  void addBudget(String name) {
    var uuid = Uuid();
    var createdAt = DateTime.now();
    _lastAddedBudgetId = uuid.v1();
    final newBudget = Budget(_lastAddedBudgetId, name, 0, createdAt);

    _items.add(newBudget);
    notifyListeners();

    final insertRes = DBHelper.insert('budgets', {
      'id': newBudget.id,
      'name': newBudget.name,
      'amount': newBudget.amount,
      'createdAt': newBudget.createdAt.toString()
    });
  }

  void updateBudget(String id, String name) {
    final ndx = _items.indexWhere((item) => item.id == id);
    _items[ndx].name = name;
    notifyListeners();
    final updateRes = DBHelper.updateBudget(id, name);
  }

  void deleteBudgget(String budgetId) {
    _items.removeWhere((item) => item.id == budgetId);
    notifyListeners();
    DBHelper.deleteBudget(budgetId);
    DBHelper.deleteBudgetItemsByBudgetId(budgetId);
  }

  Future<void> cloneBudget(String budgetId) async {
    final toCloneBudget = await DBHelper.getBudgetById(budgetId);
    print(toCloneBudget);
    final mappedBudget = Budget.fromMap(toCloneBudget.first);
    var uuid = Uuid();
    mappedBudget.id = uuid.v1();
    mappedBudget.name = mappedBudget.name + ' copy';

    _items.add(mappedBudget);
    notifyListeners();
    try {
      final insertRes = DBHelper.insert('budgets', {
        'id': mappedBudget.id,
        'name': mappedBudget.name,
        'amount': mappedBudget.amount,
        'createdAt': mappedBudget.createdAt.toString()
      });
      print('success insert');
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchAndSetBudgets() async {
    final dataList = await DBHelper.getData('budgets');

    _items = dataList
        .map((item) => Budget(item['id'], item['name'], item['amount'],
            DateTime.parse(item['createdAt'])))
        .toList();
    notifyListeners();
  }

  Budget findById(String id) {
    return _items.firstWhere((budget) => budget.id == id);
  }
}
