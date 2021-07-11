import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budgets.dart';

class AddBudgetScreen extends StatefulWidget {
  static const routeName = '/add-budget';

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudgetScreen> {
  final _nameController = TextEditingController();

  void _saveBudget() {
    if (_nameController.text.isEmpty) return;

    Provider.of<Budgets>(context, listen: false)
        .addBudget(_nameController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Budget'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Name'),
            controller: _nameController,
          ),
          RaisedButton.icon(
              onPressed: _saveBudget,
              icon: Icon(Icons.add),
              label: Text('Add Budget'))
        ],
      ),
    );
  }
}
