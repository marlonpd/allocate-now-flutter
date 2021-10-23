import 'package:allocate_now/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currencies.dart';
import '../providers/settings.dart';

class CurrencySelection extends StatelessWidget {
  void setCurrency(BuildContext context, String settingsValue) {
    Provider.of<Settings>(context, listen: false)
        .updateSettings('currency', settingsValue);
  }

  @override
  Widget build(BuildContext context) {
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
                      return Consumer<Settings>(
                        builder: (__, settings, ___) {
                          return DropdownButton<String>(
                            value: settings.findByName('currency'),
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              //defaultCurrency = newValue!;
                              setCurrency(context, newValue!);
                            },
                            items: <Currency>[
                              ...currencies.items
                            ].map<DropdownMenuItem<String>>((Currency value) {
                              return DropdownMenuItem<String>(
                                value: '${value.code}_${value.symbol}',
                                child: Text(value.code),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ));
  }
}
