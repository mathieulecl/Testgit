import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dashboard/Pages/GraphPage.dart';

class MarchesPage extends StatefulWidget {
  @override
  _MarchesPageState createState() => _MarchesPageState();
}

class _MarchesPageState extends State<MarchesPage> {
  List<dynamic> cryptoData = [];
  Map<String, AssetImage> icons = {
    "Bitcoin": AssetImage("assets/bitcoin.png"),
    "Ethereum": AssetImage("assets/ethereum.png"),
    "Binance Coin": AssetImage("assets/Binance.png"),
    "Chainlink": AssetImage("assets/Chainlink.png"),
    "Doge Coin": AssetImage("assets/dogecoin.png"),
    "Tether": AssetImage("assets/tether.png"),
    "Ripple": AssetImage("assets/xrp.png"),
  };

  @override
  void initState() {
    super.initState();
    loadCryptoData();
  }

  Future<void> loadCryptoData() async {
    final String jsonString = await rootBundle.loadString(
        'assets/cryptocurrencies_db_detailed.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    Map<String, List<Map<String, dynamic>>> currencyHistory = {};

    for (var entry in jsonResponse) {
      String date = entry['date'];
      List<dynamic> currencies = entry['currencies'];

      for (var currency in currencies) {
        String name = currency['name'];
        String symbol = currency['symbol'];
        double price = currency['price_usd'];

        if (!currencyHistory.containsKey(name)) {
          currencyHistory[name] = [];
        }
        currencyHistory[name]!.add({
          'date': date,
          'symbol': symbol,
          'price_usd': price,
        });
      }
    }

    setState(() {
      cryptoData = currencyHistory.entries.map((entry) {
        var lastEntry = entry.value.last;
        var firstEntry = entry.value.first;
        double change_24h = (lastEntry['price_usd'] - firstEntry['price_usd']) /
            firstEntry['price_usd'] * 100;

        return {
          'name': entry.key,
          'latest': lastEntry,
          'change_24h': change_24h,
          'icon': icons[entry.key], // Ensure the icon exists
          'history': entry.value, // This is the historical data for plotting
        };
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marchés'),
      ),
      body: ListView.builder(
        itemCount: cryptoData.length,
        itemBuilder: (context, index) {
          var crypto = cryptoData[index];
          // Assuming 'latest' contains the latest data including 'price_usd'
          var latestData = crypto['latest'];

          // Safely access 'price_usd' and 'change_24h', with fallbacks for null values
          String priceUsdStr = latestData['price_usd']?.toStringAsFixed(2) ??
              'N/A';
          String change24hStr = crypto['change_24h']?.toStringAsFixed(2) ??
              'N/A';

          return ListTile(
            leading: crypto['icon'] != null
                ? Image(image: crypto['icon'])
                : null,
            title: Text(crypto['name']),
            subtitle: Text('\$$priceUsdStr'),
            trailing: Text('$change24hStr%',
              style: TextStyle(
                  color: (crypto['change_24h'] ?? 0) > 0 ? Colors.green : Colors
                      .red),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GraphPage(
                    historicalData: crypto['history'],
                    cryptoName: crypto['name'], // Add this line
                    cryptoIcon: crypto['icon'], // And this line
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
