import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allocate_now/providers/settings.dart';
import 'package:allocate_now/providers/budget_items.dart';

class BudgetSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _totalBudgetAmount =
        Provider.of<BudgetItems>(context, listen: true).totalBudgetAmount;
    final _totalExpenses =
        Provider.of<BudgetItems>(context, listen: true).totalExpenses;
    final _budgetOverruns =
        Provider.of<BudgetItems>(context, listen: true).budgetOverruns;
    final _totalPaidAmount =
        Provider.of<BudgetItems>(context, listen: true).totalPaidAmount;
    final _currencySymbol =
        Provider.of<Settings>(context, listen: false).currencySymbol;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('ToTal Budget'),
                Text('$_currencySymbol ${_totalBudgetAmount.toString()}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total Expenses'),
                Text('$_currencySymbol ${_totalExpenses.toString()}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total overruns'),
                Text('$_currencySymbol ${_budgetOverruns.toString()}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total Paid Amount'),
                Text('$_currencySymbol ${_totalPaidAmount.toString()}')
              ],
            )
          ],
        ),
      ),
    );
  }
}
