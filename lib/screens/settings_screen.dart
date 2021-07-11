import 'package:allocate_now/widgets/currency_selection.dart';
import 'package:allocate_now/widgets/user_email_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<Settings>(context, listen: false).fetchAndSetSettings();
    // final _userEmail =
    //     Provider.of<Settings>(context, listen: false).findByName('email');
    // print('settings');
    // print(_userEmail);
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: Icon(Icons.save_rounded))
          ],
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

// class SettingsScreen extends StatefulWidget {
//   static const routeName = '/settings';
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   String dropdownValue = {"symbol": "\$", "name": "US - Dollar"}.toString();

//   @override
//   Widget build(BuildContext context) {
//     // List<Map<String, String>> currencies =
//     //     await Provider.of<Settings>(context, listen: false).getCurrencies();

//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Settings'),
//           actions: <Widget>[
//             IconButton(onPressed: () {}, icon: Icon(Icons.save_rounded))
//           ],
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(10),
//           child: Column(children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Currency Symbol '),
//                 CurrencySelection(),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Email'),
//                 GestureDetector(
//                     onDoubleTap: () {}, child: Text('email@yahoo.com')),
//               ],
//             )
//           ]),
//         ));
//   }
// }
