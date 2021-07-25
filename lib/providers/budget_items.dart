import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../helpers/db_helper.dart';
import '../models/budget_item.dart';
import '../helpers/constants.dart';
import 'budgets.dart';

class BudgetItems with ChangeNotifier {
  List<BudgetItem> _items = [];
  double _totalBudgetAmount = 0;
  double _totalExpenses = 0;
  double _budgetOverruns = 0;
  double _totalPaidAmount = 0;

  List<BudgetItem> get items {
    return [..._items];
  }

  double get totalBudgetAmount {
    return _totalBudgetAmount;
  }

  double get totalExpenses {
    return _totalExpenses;
  }

  double get budgetOverruns {
    return _budgetOverruns;
  }

  double get totalPaidAmount {
    return _totalPaidAmount;
  }

  void deleteBudgetItem(String budgetItemId) {
    _items.removeWhere((item) => item.id == budgetItemId);
    calculateRunningBalance();
    notifyListeners();
    DBHelper.deleteBudgetItem(budgetItemId);
  }

  void toggleSetPaidBudgetItem(String budgetItemId, isPaid) {
    final isBudgetItemPaid = isPaid == 0 ? 1 : 0;
    _items[_items.indexWhere((item) => item.id == budgetItemId)].isPaid =
        isBudgetItemPaid;
    calculateRunningBalance();
    notifyListeners();
    DBHelper.toggleSetPaidBudgetItem(budgetItemId, isBudgetItemPaid);
  }

  void updateBudgetItem(String budgetItemId, String name, double unitCount,
      double amount, double totalAmount) async {
    try {
      //_items.add(newBudgetItem);
      var index = _items.indexWhere((item) => item.id == budgetItemId);
      _items[index].name = name;
      _items[index].unitCount = unitCount;
      _items[index].amount = amount;
      _items[index].totalAmount = totalAmount;

      notifyListeners();

      await DBHelper.updateBudgetItem(
          budgetItemId, name, unitCount, amount, totalAmount);
    } catch (e) {
      print('error ');
      print(e);
    }
  }

  void calculateRunningBalance() {
    double runningBalance = 0;
    _totalBudgetAmount = 0;
    _totalExpenses = 0;
    _budgetOverruns = 0;
    _totalPaidAmount = 0;

    _items = _items.map((item) {
      runningBalance = item.entryType == EntryType.expenses.toString()
          ? runningBalance - item.totalAmount
          : runningBalance + item.totalAmount;
      item.runningBalance = runningBalance;

      if (item.entryType == EntryType.income.toString()) {
        _totalBudgetAmount = _totalBudgetAmount + item.totalAmount;
      }

      if (item.entryType == EntryType.expenses.toString()) {
        _totalExpenses = _totalExpenses + item.totalAmount;
      }

      if (item.isPaid == 1) {
        _totalPaidAmount = _totalPaidAmount + item.totalAmount;
      }

      return item;
    }).toList();

    if (_items.length > 0) {
      final budgetId = _items[0].budgetId;

      (new Budgets())
          .updateSpecificBudgetTotalAmount(budgetId, _totalBudgetAmount);
    }

    _budgetOverruns = _totalBudgetAmount - _totalExpenses;
  }

  void addBudgetItem(String budgetId, String name, String entryType,
      double unitCount, double amount, double totalAmount) async {
    var uuid = Uuid();
    final newBudgetItem = BudgetItem(uuid.v1(), budgetId, name, entryType,
        unitCount, amount, totalAmount, 0, 0, 0);

    try {
      _items.add(newBudgetItem);
      calculateRunningBalance();
      notifyListeners();

      await DBHelper.insert('budgetItems', {
        'id': newBudgetItem.id,
        'budgetId': newBudgetItem.budgetId,
        'name': newBudgetItem.name,
        'unitCount': newBudgetItem.unitCount,
        'amount': newBudgetItem.amount,
        'entryType': newBudgetItem.entryType.toString(),
        'totalAmount': newBudgetItem.totalAmount,
        'isPaid': newBudgetItem.isPaid,
        'dueDate': newBudgetItem.dueDate
      });
    } catch (e) {
      print('Error adding new item');
      print(e);
    }
  }

  Future<void> setDueDate(String budgetItemId, DateTime dueDate) async {
    try {
      var index = _items.indexWhere((item) => item.id == budgetItemId);
      _items[index].dueDate = dueDate.millisecondsSinceEpoch;

      notifyListeners();

      await DBHelper.setDueDate(budgetItemId, dueDate.millisecondsSinceEpoch);
    } catch (e) {
      print('error ');
      print(e);
    }
  }

  Future<void> fetchAndSetBudgetItemsByBudgetId(String budgetId) async {
    try {
      final dataList = await DBHelper.getBudgetItemsByBudgetId(budgetId);
      double runningBalance = 0;
      _items = dataList.map((item) {
        runningBalance = item['entryType'] == EntryType.expenses
            ? runningBalance - item['totalAmount'].toDouble()
            : runningBalance + item['totalAmount'].toDouble();

        var budgetItm = BudgetItem(
            item['id'],
            item['budgetId'],
            item['name'],
            item['entryType'],
            item['unitCount'].toDouble(),
            item['amount'],
            item['totalAmount'],
            runningBalance,
            item['isPaid'],
            item['dueDate']);

        print(budgetItm.id);

        return budgetItm;
      }).toList();
    } catch (error) {
      print('what');
      print(error);
    }

    calculateRunningBalance();

    notifyListeners();
  }

  Future<double> getTotalAmountByBudgetId(String budgetId) async {
    final dataList = await DBHelper.getBudgetItemsByBudgetId(budgetId);
    double runningBalance = 0;

    dataList.forEach((element) {
      runningBalance = element['entryType'] == EntryType.expenses
          ? runningBalance - element['totalAmount'].toDouble()
          : runningBalance + element['totalAmount'].toDouble();
    });

    return runningBalance;

    //      dataList..reduce((value, element){
    //   return {
    //     // sum the population here
    //     "population": value["population"] + element["population"],
    //     // sum the area here
    //     "area": value["area"] + element["area"],
    //   };
    // });
  }
}
