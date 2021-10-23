import 'package:allocate_now/models/budget_item.dart';
import 'package:allocate_now/widgets/add_new_budget_item_form.dart';
import 'package:allocate_now/widgets/add_new_expenses_item_form.dart';
import 'package:allocate_now/widgets/budget_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

//import '../providers/budgets.dart';
import '../providers/budget_items.dart';
import '../providers/settings.dart';
import '../helpers/constants.dart';

class BudgetItemsScreen extends StatefulWidget {
  static const routeName = '/budget-item';

  @override
  _BudgetItemsScreenState createState() => _BudgetItemsScreenState();
}

class _BudgetItemsScreenState extends State<BudgetItemsScreen> {
  final _nameController = TextEditingController();

  final _unitCountController = TextEditingController();

  final _amountController = TextEditingController();

  //late final DateTime _dateTime;

  var budgetId = '';

  bool isAddNewBudget = false;

  bool isAddNewExpenses = false;

  void setIsAddNewBudgetFalse() {
    setState(() {
      isAddNewBudget = false;
    });
  }

  void setIsAddNewExpensesFalse() {
    setState(() {
      isAddNewExpenses = false;
    });
  }

  void _saveBudgetItem(BuildContext context, EntryType etype) {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    final double _unitCount = _unitCountController.text.isEmpty
        ? 1
        : double.parse(_unitCountController.text);
    final double _amount = double.parse(_amountController.text);
    final double _totalAmount = _unitCount * _amount;

    Provider.of<BudgetItems>(context, listen: false).addBudgetItem(
        budgetId,
        _nameController.text,
        etype.toString(),
        _unitCount,
        _amount,
        _totalAmount);

    Navigator.of(context).pop();
  }

  void _updateBudgetItem(BuildContext context, BudgetItem budgetItem) {
    if (_nameController.text.isEmpty ||
        _unitCountController.text.isEmpty ||
        _amountController.text.isEmpty) return;

    final double _unitCount = double.parse(_unitCountController.text);
    final double _amount = double.parse(_amountController.text);
    final double _totalAmount = _unitCount * _amount;

    Provider.of<BudgetItems>(context, listen: false).updateBudgetItem(
        budgetItem.id, _nameController.text, _unitCount, _amount, _totalAmount);

    Navigator.of(context).pop();
  }

  void _deleteBudgetItem(ctx, String budgetItemId) {
    Provider.of<BudgetItems>(ctx, listen: false).deleteBudgetItem(budgetItemId);
  }

  void _setPaid(ctx, String budgetItemId, isPaid) {
    Provider.of<BudgetItems>(ctx, listen: false)
        .toggleSetPaidBudgetItem(budgetItemId, isPaid);
  }

  void _startAddNewExpenses(BuildContext context) {
    _nameController.text = '';
    _unitCountController.text = '';
    _amountController.text = '';

    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Unit Count'),
                    controller: _unitCountController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _saveBudgetItem(context, EntryType.expenses);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Expenses'))
                ],
              ),
            ),
          );
        });
  }

  void _startAddNewBudget(BuildContext context) {
    _nameController.text = '';
    _unitCountController.text = '';
    _amountController.text = '';

    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _saveBudgetItem(context, EntryType.income);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Budget'))
                ],
              ),
            ),
          );
        });
  }

  void _showDatePicker(BuildContext context, String budgetItemId) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(2022))
        .then((dueDate) {
      if (dueDate != null) {
        Provider.of<BudgetItems>(context, listen: false)
            .setDueDate(budgetItemId, dueDate);
      }
    });
  }

  void _startEditBudgetItem(BuildContext context, BudgetItem budgetItem) {
    _nameController.text = budgetItem.name;
    _unitCountController.text = budgetItem.unitCount.toString();
    _amountController.text = budgetItem.amount.toString();

    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Unit Count'),
                    controller: _unitCountController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _updateBudgetItem(context, budgetItem);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Update'))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('Building parent');
    budgetId = ModalRoute.of(context)?.settings.arguments as String;
    // final runningBalance = 0;
    // final selectedBudget =
    //     Provider.of<Budgets>(context, listen: false).findById(budgetId);
    final _currencySymbol =
        Provider.of<Settings>(context, listen: true).currencySymbol;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Your Budgets'),
        actions: <Widget>[
          IconButton(
              onPressed: () => _startAddNewExpenses(context),
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<BudgetItems>(context, listen: false)
            .fetchAndSetBudgetItemsByBudgetId(budgetId),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Consumer<BudgetItems>(
                            child: Center(child: Text('No budget created')),
                            builder: (ctxx, budgetItems, _child) {
                              if (budgetItems.items.length <= 0)
                                return _child as Widget;

                              return Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: budgetItems.items.length,
                                    itemBuilder: (ctx, i) => _budgetItem(
                                        context,
                                        i,
                                        budgetItems.items[i],
                                        _currencySymbol),
                                  ),
                                  if (!isAddNewExpenses && !isAddNewBudget)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                isAddNewBudget = true;
                                              });
                                            },
                                            icon: Icon(Icons.add),
                                            label: Text('Add Budget')),
                                        ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                isAddNewExpenses = true;
                                              });
                                            },
                                            icon: Icon(Icons.add),
                                            label: Text('Add Expenses'))
                                      ],
                                    ),
                                  if (isAddNewExpenses)
                                    AddNewExpensesItemForm(
                                      budgetId: budgetId,
                                      setIsAddNewExpensesFalse:
                                          setIsAddNewExpensesFalse,
                                    ),
                                  if (isAddNewBudget)
                                    AddNewBudgetItemForm(
                                      budgetId: budgetId,
                                      setIsAddNewBudgetItemFalse:
                                          setIsAddNewBudgetFalse,
                                    ),
                                ],
                              );
                            }),
                      ),
                      Container(child: BudgetSummary())
                    ],
                  ),
      ),
    );
  }

  Widget _budgetItem(BuildContext context, int index, BudgetItem budgetItem,
      String _currencySymbol) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: GestureDetector(
        onDoubleTap: () {
          _startEditBudgetItem(context, budgetItem);
        },
        child: ListTile(
          leading: Text(
            budgetItem.name,
            style: budgetItem.isPaid == 1
                ? new TextStyle(
                    color: budgetItem.entryType == EntryType.expenses.toString()
                        ? Colors.red
                        : Colors.green,
                    decoration: TextDecoration.lineThrough,
                  )
                : new TextStyle(
                    color: budgetItem.entryType == EntryType.expenses.toString()
                        ? Colors.red
                        : Colors.green,
                  ),
          ),
          title: Text('$_currencySymbol ${budgetItem.amount.toString()}'),
          subtitle: (budgetItem.dueDate > 0)
              ? Text(DateTime.fromMillisecondsSinceEpoch(budgetItem.dueDate)
                  .toString())
              : null,
          trailing: Column(
            children: <Widget>[
              Text('$_currencySymbol ${budgetItem.totalAmount.toString()}'),
              Text('$_currencySymbol ${budgetItem.runningBalance.toString()}'),
            ],
          ),
          onTap: null,
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Due',
          color: Colors.orange,
          icon: Icons.calendar_today_outlined,
          onTap: () => {_showDatePicker(context, budgetItem.id)},
        ),
        if (EntryType.expenses.toString() == budgetItem.entryType)
          IconSlideAction(
            caption: 'Paid',
            color: Colors.orange,
            icon: Icons.check,
            onTap: () => {_setPaid(context, budgetItem.id, budgetItem.isPaid)},
          ),
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit_outlined,
          onTap: () => {_startEditBudgetItem(context, budgetItem)},
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            if (await confirm(
              context,
              title: Text('Confirm'),
              content: Text('Would you like to remove?'),
              textOK: Text('Yes'),
              textCancel: Text('No'),
            )) {
              return _deleteBudgetItem(context, budgetItem.id);
            }
            return;
          },
        ),
      ],
    );
  }
}
