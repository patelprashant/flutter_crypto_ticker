import 'dart:io';

import 'package:bitcoin_ticker_app/crypto_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var selectedCurrency = 'AUD';
  String bitCoinValue = '?';
  bool isWaiting = false;
  Map<String, String> bitCoinValueMap = {};

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> ddCurrencies = [];
    for (String currency in currenciesList) {
      var newCurrency = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      ddCurrencies.add(newCurrency);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: ddCurrencies,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> ddCurrencies = [];
    for (String currency in currenciesList) {
      ddCurrencies.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: ddCurrencies,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
    );
  }

  void getData() async {
    isWaiting = true;

    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        bitCoinValueMap = data;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: 'BTC',
            bitCoinValue: isWaiting ? '?' : bitCoinValueMap['BTC'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'ETH',
            bitCoinValue: isWaiting ? '?' : bitCoinValueMap['ETH'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'LTC',
            bitCoinValue: isWaiting ? '?' : bitCoinValueMap['LTC'],
            selectedCurrency: selectedCurrency,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
