import 'package:allocate_now/models/budget_item.dart';
import 'package:allocate_now/widgets/add_new_budget_item_form.dart';
import 'package:allocate_now/widgets/budget_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import '../providers/budgets.dart';
import '../providers/budget_items.dart';
import '../providers/settings.dart';
import '../helpers/constants.dart';

class BudgetItemsScreen extends StatelessWidget {
  static const routeName = '/budget-item';

  final _nameController = TextEditingController();
  final _unitCountController = TextEditingController();
  final _amountController = TextEditingController();
  late final DateTime _dateTime;
  var budgetId = '';

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
                  RaisedButton.icon(
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
                  RaisedButton.icon(
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
    final runningBalance = 0;
    final selectedBudget =
        Provider.of<Budgets>(context, listen: false).findById(budgetId);
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
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
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
                                itemBuilder: (ctx, i) => Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      _startEditBudgetItem(
                                          context, budgetItems.items[i]);
                                    },
                                    child: ListTile(
                                      leading: Text(
                                        budgetItems.items[i].name,
                                        style: budgetItems.items[i].isPaid == 1
                                            ? new TextStyle(
                                                color: budgetItems.items[i]
                                                            .entryType ==
                                                        EntryType.expenses
                                                            .toString()
                                                    ? Colors.red
                                                    : Colors.green,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              )
                                            : new TextStyle(
                                                color: budgetItems.items[i]
                                                            .entryType ==
                                                        EntryType.expenses
                                                            .toString()
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                      ),
                                      title: Text(
                                          '$_currencySymbol ${budgetItems.items[i].amount.toString()}'),
                                      subtitle: (budgetItems.items[i].dueDate >
                                              0)
                                          ? Text(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      budgetItems
                                                          .items[i].dueDate)
                                              .toString())
                                          : null,
                                      trailing: Column(
                                        children: <Widget>[
                                          Text(
                                              '$_currencySymbol ${budgetItems.items[i].totalAmount.toString()}'),
                                          Text(
                                              '$_currencySymbol ${budgetItems.items[i].runningBalance.toString()}'),
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
                                      onTap: () => {
                                        _showDatePicker(
                                            context, budgetItems.items[i].id)
                                      },
                                    ),
                                    if (EntryType.expenses.toString() ==
                                        budgetItems.items[i].entryType)
                                      IconSlideAction(
                                        caption: 'Paid',
                                        color: Colors.orange,
                                        icon: Icons.check,
                                        onTap: () => {
                                          _setPaid(
                                              context,
                                              budgetItems.items[i].id,
                                              budgetItems.items[i].isPaid)
                                        },
                                      ),
                                    IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.blue,
                                      icon: Icons.edit_outlined,
                                      onTap: () => {
                                        _startEditBudgetItem(
                                            context, budgetItems.items[i])
                                      },
                                    ),
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () async {
                                        if (await confirm(
                                          context,
                                          title: Text('Confirm'),
                                          content:
                                              Text('Would you like to remove?'),
                                          textOK: Text('Yes'),
                                          textCancel: Text('No'),
                                        )) {
                                          return _deleteBudgetItem(
                                              context, budgetItems.items[i].id);
                                        }
                                        return;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              AddNewBudgetItemForm(budgetId: budgetId),
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
}
