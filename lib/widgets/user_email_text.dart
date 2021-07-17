import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';

class UserEmailText extends StatelessWidget {
  final _emailController = TextEditingController();
  String _userEmail = '';

  Future<dynamic> _startSetEmail(BuildContext ctx) {
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

    Provider.of<Settings>(ctx, listen: false)
        .updateSettings('email', _emailController.text);
    Navigator.of(ctx).pop(_userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onDoubleTap: () async {
      await _startSetEmail(context);
    }, child: Consumer<Settings>(builder: (_, settings, __) {
      return Text(settings.findByName('email'));
    }));
  }
}
