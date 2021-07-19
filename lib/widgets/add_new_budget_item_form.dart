import 'package:allocate_now/helpers/constants.dart';
import 'package:allocate_now/providers/budget_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewBudgetItemForm extends StatefulWidget {
  final String budgetId;
  const AddNewBudgetItemForm({Key? key, required this.budgetId})
      : super(key: key);

  @override
  _AddNewBudgetItemFormState createState() => _AddNewBudgetItemFormState();
}

class _AddNewBudgetItemFormState extends State<AddNewBudgetItemForm> {
  final _nameController = TextEditingController();
  final _unitCountController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }

  void _saveBudgetItem(BuildContext context, EntryType etype) {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    final double _unitCount = _unitCountController.text.isEmpty
        ? 1
        : double.parse(_unitCountController.text);
    final double _amount = double.parse(_amountController.text);
    final double _totalAmount = _unitCount * _amount;

    Provider.of<BudgetItems>(context, listen: false).addBudgetItem(
        widget.budgetId,
        _nameController.text,
        etype.toString(),
        _unitCount,
        _amount,
        _totalAmount);
  }
}
