import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/budgets.dart';
import './providers/budget_items.dart';
import './providers/settings.dart';
import './providers/currencies.dart';
import './screens/budgets_screen.dart';
import './screens/add_budget_screen.dart';
import './screens/budget_items_screen.dart';
import './screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'package:allocate_now/helpers/db_helper.dart';

void main() {
  runApp(AllocateNow());
}

class AllocateNow extends StatelessWidget {
  final Future<String> _initDb = Future<String>.delayed(
    const Duration(seconds: 2),
    () async => await DBHelper.dbInit(),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: _initDb,
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: SplashScreen());
        } else {
          // Loading is done, return the app:
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<Budgets>(
                  create: (ctx) => Budgets(),
                ),
                ChangeNotifierProvider<BudgetItems>(
                  create: (ctx) => BudgetItems(),
                ),
                ChangeNotifierProvider<Settings>(create: (ctx) => Settings()),
                ChangeNotifierProvider<Currencies>(
                    create: (ctx) => Currencies()),
              ],
              child: MaterialApp(
                title: 'AllocateNow',
                theme: ThemeData(
                    primaryColor: Colors.blue, primarySwatch: Colors.amber),
                home: BudgetsScreen(),
                routes: {
                  AddBudgetScreen.routeName: (ctx) => AddBudgetScreen(),
                  BudgetItemsScreen.routeName: (ctx) => BudgetItemsScreen(),
                  SettingsScreen.routeName: (ctx) => SettingsScreen()
                },
                debugShowCheckedModeBanner: false,
              ));
        
        }
      },
    );
  }
}
