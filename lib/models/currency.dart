class Currency {
  String symbol = '';
  String name = '';

  Currency(this.symbol, this.name);

  Currency.fromMap(Map<String, dynamic?> val) {
    this.symbol = val['symbol'];
    this.name = val['name'];
  }
}
