import 'package:allocate_now/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currencies.dart';
import '../providers/settings.dart';
import 'dart:convert';

class CurrencySelection extends StatefulWidget {
  const CurrencySelection({Key? key}) : super(key: key);

  @override
  _CurrencySelectionState createState() => _CurrencySelectionState();
}

class _CurrencySelectionState extends State<CurrencySelection> {
  //{"symbol": "\$", "name": "US - Dollar"}.toString();

  void setCurrency(String settingsValue) {
    setState(() {
      Provider.of<Settings>(context, listen: false)
          .updateSettings('currency', json.encode(settingsValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    String defaultCurrency = {"symbol": "\$", "name": "US - Dollar"}.toString();
    String settingsCurrency = defaultCurrency;
    // //Provider.of<Settings>(context, listen: false).findByName('currency'); //
    // print('------------');
    // print(settingsCurrency);
    // if (settingsCurrency.isEmpty) {
    //   settingsCurrency = defaultCurrency;
    // }
    // print('------------');
    return FutureBuilder(
        future: Provider.of<Currencies>(context, listen: false).getCurrencies(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Currencies>(
                    child: Center(child: Text('Fetching')),
                    builder: (ctx, currencies, _ch) {
                      return DropdownButton<String>(
                        value: settingsCurrency,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            settingsCurrency = newValue!;
                            setCurrency(settingsCurrency);
                          });
                        },
                        items: <Currency>[...currencies.items]
                            .map<DropdownMenuItem<String>>((Currency value) {
                          return DropdownMenuItem<String>(
                            value: {'symbol': value.symbol, 'name': value.name}
                                .toString(),
                            child: Text(value.name),
                          );
                        }).toList(),
                      );
                    },
                  ));
  }
}
