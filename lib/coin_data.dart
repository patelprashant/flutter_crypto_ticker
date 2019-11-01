import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitCoinAverageUrl =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPricesMap = {};

    for (String crypto in cryptoList) {
      String reqUrl = '$bitCoinAverageUrl/$crypto$selectedCurrency';
//      print(reqUrl);
      http.Response response = await http.get(reqUrl);
      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        double lastPrice = decodeData['last'];
        cryptoPricesMap[crypto] = lastPrice.toStringAsFixed(0);
//        print('crypto is-$crypto');
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPricesMap;
  }
}
