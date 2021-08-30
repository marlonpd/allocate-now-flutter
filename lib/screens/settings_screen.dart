import 'package:allocate_now/widgets/currency_selection.dart';
import 'package:allocate_now/widgets/user_email_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings.dart';
import '../helpers/file_helper.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<Settings>(context, listen: false).fetchAndSetSettings();

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Currency Symbol ')),
                Expanded(child: CurrencySelection()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Email')),
                Expanded(child: UserEmailText()),
              ],
            )
          ]),
        ));
  }
}
