import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dashboard/Pages/GraphPage.dart';

class MarchesPage extends StatefulWidget {
  @override
  _MarchesPageState createState() => _MarchesPageState();
}

class _MarchesPageState extends State<MarchesPage> {
  List<dynamic> cryptoData = [];
  Map<String, AssetImage> icons = {
    "Bitcoin": AssetImage("assets/icon/bitcoin.png"),
    "Ethereum": AssetImage("assets/icon/ethereum.png"),
    "Binance Coin": AssetImage("assets/icon/Binance.png"),
    "Chainlink": AssetImage("assets/icon/Chainlink.png"),
    "Dogecoin": AssetImage("assets/icon/dogecoin.png"),
    "Tether": AssetImage("assets/icon/tether.png"),
    "XRP": AssetImage("assets/icon/xrp.png"),
  };
  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<List> fetchHistoricalData(String coinId) async {
    const days = 'max';
    const interval = 'daily';
    final String historicalDataUrl = 'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=$days&interval=$interval';
    final response = await http.get(Uri.parse(historicalDataUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List historicalData = data['prices'].map((price) {
        return {'timestamp': price[0], 'price': price[1]};
      }).toList();
      return historicalData;
    } else {
      throw Exception('Failed to load historical data');
    }
  }

  Future<void> fetchCryptoData() async {
    const String apiUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        cryptoData = data.where((crypto) => icons.containsKey(crypto['name'])).map((crypto) => {
          'name': crypto['name'],
          'symbol': crypto['symbol'],
          'current_price': crypto['current_price'],
          'image': icons[crypto['name']],
          'price_change_percentage_24h': crypto['price_change_percentage_24h'],
          'id': crypto['id']
        }).toList();
      });
    } else {
      throw Exception('Failed to load crypto data');
    }
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
          return ListTile(
            leading: Image(image: crypto['image']),
            title: Text(crypto['name']),
            subtitle: Text('\$${crypto['current_price']}'),
            trailing: Text('${crypto['price_change_percentage_24h']?.toStringAsFixed(2)}%',
              style: TextStyle(
                  color: (crypto['price_change_percentage_24h'] ?? 0) > 0 ? Colors.green : Colors.red),
            ),
            onTap: () async {
              var historicalData = await fetchHistoricalData(crypto['id']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GraphPage(
                    cryptoId: crypto['id'],
                    cryptoName: crypto['name'],
                    cryptoIconUrl: crypto['image'],
                    historicalData: historicalData,
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
