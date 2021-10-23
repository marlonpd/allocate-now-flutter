import '../helpers/constants.dart';

class BudgetItem {
  String id = '';
  String budgetId = '';
  String name = '';
  String entryType = EntryType.expenses.toString();
  double unitCount = 0;
  double amount = 0;
  double totalAmount = 0;
  double runningBalance = 0;
  int isPaid = 0;
  int dueDate = 0;

  BudgetItem(
      this.id,
      this.budgetId,
      this.name,
      this.entryType,
      this.unitCount,
      this.amount,
      this.totalAmount,
      this.runningBalance,
      this.isPaid,
      this.dueDate);

  BudgetItem.fromMap(Map<String, dynamic?> map) {
    this.id = map['id'];
    this.budgetId = map['budgetId'];
    this.name = map['name'];
    this.entryType = map['entryType'];
    this.unitCount = double.parse(map['unitCount']);
    this.amount = double.parse(map['amount']);
    this.totalAmount = double.parse(map['totalAmount']);
    this.runningBalance = double.parse(map['runningBalance']);
    this.isPaid = int.parse(map['isPaid']);
    this.dueDate = map['dueDate'];
  }
}
