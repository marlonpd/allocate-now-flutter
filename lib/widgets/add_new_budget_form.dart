import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allocate_now/helpers/constants.dart';
import 'package:allocate_now/providers/budget_items.dart';
import 'package:allocate_now/providers/budgets.dart';
import 'package:allocate_now/screens/budget_items_screen.dart';

class AddNewBudgetForm extends StatefulWidget {
  AddNewBudgetForm({Key? key}) : super(key: key);

  @override
  _AddNewBudgetFormState createState() => _AddNewBudgetFormState();
}

class _AddNewBudgetFormState extends State<AddNewBudgetForm> {
  final _nameController = TextEditingController();
  final _initialBudgetController = TextEditingController();
  final _editNameController = TextEditingController();

  bool isAddNewBudget = false;

  void _saveBudget(ctx) {
    if (_nameController.text.isEmpty) return;

    Provider.of<Budgets>(ctx, listen: false).addBudget(_nameController.text);
    final lastAddedBudgetId =
        Provider.of<Budgets>(ctx, listen: false).lastAddedBudgetId;
    _saveInitialBudgetItem(
        ctx, lastAddedBudgetId, double.parse(_initialBudgetController.text));
    _nameController.text = '';
    _initialBudgetController.text = '';
    Navigator.of(ctx)
        .pushNamed(
      BudgetItemsScreen.routeName,
      arguments: lastAddedBudgetId,
    )
        .then((_) {
      setState(() {});
    });
  }

  void _updateBudget(ctx, String budgetId) {
    if (_nameController.text.isEmpty) return;

    Provider.of<Budgets>(ctx, listen: false)
        .updateBudget(budgetId, _nameController.text);
    _nameController.text = '';
    isAddNewBudget = false;
  }

  void _saveInitialBudgetItem(
      BuildContext context, String budgetId, double initialBudget) {
    Provider.of<BudgetItems>(context, listen: false).addBudgetItem(
        budgetId,
        'Initial Budget',
        EntryType.income.toString(),
        1,
        initialBudget,
        initialBudget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (isAddNewBudget) _buildNewBudgetForm(context),
        if (!isAddNewBudget)
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isAddNewBudget = true;
                });
              },
              child: Text('Add new'))
      ],
    );
  }

  Widget _buildNewBudgetForm(ctx) {
    return Container(
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
              keyboardType: TextInputType.number,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isAddNewBudget = false;
                      });
                      _saveBudget(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add')),
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isAddNewBudget = false;
                      });
                    },
                    icon: Icon(Icons.cancel),
                    label: Text('Cancel'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
