import 'package:allocate_now/models/budget.dart';
import 'package:allocate_now/widgets/add_new_budget_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:allocate_now/providers/budgets.dart';
import './budget_items_screen.dart';
import '../providers/budgets.dart';
import '../providers/budget_items.dart';
import '../providers/settings.dart';
import '../screens/settings_screen.dart';
import '../helpers/constants.dart';
import 'dart:convert';

class BudgetsScreen extends StatefulWidget {
  @override
  _BudgetsScreenState createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final _nameController = TextEditingController();

  final _initialBudgetController = TextEditingController();

  final _editNameController = TextEditingController();

  bool isAddNewBudget = false;

  int indexToEdit = -1;

  void _updateBudget(ctx, String budgetId) {
    if (_nameController.text.isEmpty) return;

    Provider.of<Budgets>(ctx, listen: false)
        .updateBudget(budgetId, _nameController.text);
    _nameController.text = '';
    Navigator.of(ctx).pop();
  }

  void _cloneBudget(BuildContext ctx, String budgetId) {
    Provider.of<Budgets>(ctx, listen: false).cloneBudget(budgetId);
  }

  void startAddNewBudget(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
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
                    decoration: InputDecoration(labelText: 'Initial Budget'),
                    controller: _initialBudgetController,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Text('Add Budget'))
                ],
              ),
            ),
          );
        });
  }

  void startEditBudget(BuildContext ctx, Budget budget) {
    _nameController.text = budget.name;
    showModalBottomSheet(
        context: ctx,
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
                    decoration: InputDecoration(labelText: 'Initial Budget'),
                    controller: _initialBudgetController,
                  ),
                  ElevatedButton.icon(
                      onPressed: () => _updateBudget(ctx, budget.id),
                      icon: Icon(Icons.update),
                      label: Text('Upadate'))
                ],
              ),
            ),
          );
        });
  }

  void _deleteBudget(ctx, String budgetId) {
    Provider.of<Budgets>(ctx, listen: false).deleteBudgget(budgetId);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Settings>(context, listen: false).fetchAndSetSettings();

    // String _currencySymbol =
    //     Provider.of<Settings>(context, listen: false).currencySymbol;
    // final _settings = Provider.of<Settings>(context, listen: false).settings;
    // print(_settings.length);
    // print(json.encode(_settings));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Your Budgets'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              SettingsScreen.routeName,
            );
          },
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                startAddNewBudget(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future:
              Provider.of<Budgets>(context, listen: false).fetchAndSetBudgets(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Budgets>(
                      child: Center(child: Text('No budget created')),
                      builder: (ctxx, budgets, _child) {
                        if (budgets.items.length <= 0) return _child as Widget;

                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: budgets.items.length,
                              itemBuilder: (ctx, i) => (i == indexToEdit)
                                  ? _editBudgetnameField()
                                  : _budgetItem(ctx, i, budgets.items[i]),
                            ),
                            AddNewBudgetForm(),
                          ],
                        );
                      }),
        ),
      ),
    );
  }

  Widget _editBudgetnameField() {
    return Container(
      child: Focus(
        child: TextField(
          controller: _editNameController,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            print('enter');
          } else {
            setState(() {
              indexToEdit = -1;
            });
          }
        },
      ),
    );
  }

  Widget _budgetItem(BuildContext context, int index, Budget budget) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: GestureDetector(
            child: ListTile(
              title: Text(
                budget.name,
              ),
              subtitle: Text(budget.id),
              trailing: Text(
                budget.totalAmount.toString(),
              ),
            ),
            onDoubleTap: () {
              setState(() {
                indexToEdit = index;
                _editNameController.text = budget.name;
              });
              //startEditBudget(context, budget);
            },
            onTap: () {
              Navigator.of(context).pushNamed(
                BudgetItemsScreen.routeName,
                arguments: budget.id,
              );
            }),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Clone',
          color: Colors.orange,
          icon: Icons.copy_outlined,
          onTap: () => {_cloneBudget(context, budget.id)},
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
                return _deleteBudget(context, budget.id);
              }
              return;
            }),
      ],
    );
  }
}
