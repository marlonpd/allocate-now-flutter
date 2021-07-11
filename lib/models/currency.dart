class Currency {
  String symbol = '';
  String code = '';

  Currency(this.symbol, this.code);

  Currency.fromMap(Map<String, dynamic?> val) {
    this.symbol = val['symbol'];
    this.code = val['name'];
  }
}
