import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allocate_now/models/currency.dart';

import '../providers/currencies.dart';
import '../providers/settings.dart';

class UserEmailText extends StatefulWidget {
  const UserEmailText({Key? key}) : super(key: key);

  @override
  _UserEmailTextState createState() => _UserEmailTextState();
}

class _UserEmailTextState extends State<UserEmailText> {
  final _emailController = TextEditingController();
  String _userEmail = '';
  int _counter = 0;

  Future<dynamic> _startSetEmail(BuildContext ctx) {
    setState(() {});
    _userEmail = 'test';
    _counter++;
    return showModalBottomSheet<String>(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {
              Navigator.of(ctx).pop('');
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _emailController,
                  ),
                  ElevatedButton.icon(
                      onPressed: () => _saveEmail(ctx),
                      icon: Icon(Icons.add),
                      label: Text('Save Email'))
                ],
              ),
            ),
          );
        });
  }

  void _saveEmail(ctx) {
    if (_emailController.text.isEmpty) return;

    // setState(() {
    //   _userEmail = _emailController.text;
    // });

    // setState(() {});
    Provider.of<Settings>(ctx, listen: false)
        .updateSettings('email', _emailController.text);
    Navigator.of(ctx).pop(_userEmail);
  }

  @override
  Widget build(BuildContext context) {
    _userEmail =
        Provider.of<Settings>(context, listen: true).findByName('email');

    return GestureDetector(
        onDoubleTap: () async {
          await _startSetEmail(context);
        },
        child: Text(_userEmail));
  }
}
