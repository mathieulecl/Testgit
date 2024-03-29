import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HighLowChange extends StatefulWidget {
  @override
  _HighLowChangeState createState() => _HighLowChangeState();
}

class _HighLowChangeState extends State<HighLowChange> {
  List<dynamic> cryptoData = [];
  Map<String, AssetImage> icons = {
    "Bitcoin": AssetImage("assets/icon/bitcoin.png"),
    "Ethereum": AssetImage("assets/icon/ethereum.png"),
    "Chainlink": AssetImage("assets/icon/chainlink.png"),
    "Dogecoin": AssetImage("assets/icon/dogecoin.png"),
    "Tether": AssetImage("assets/icon/tether.png"),
  };

  Timer? _timer; // Declare a Timer

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
    startAutoUpdate(); // Start the auto-update process
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startAutoUpdate() {
    const duration = Duration(seconds: 60); // Set the update frequency
    _timer = Timer.periodic(duration, (Timer t) => fetchCryptoData());
  }

  Future<List> fetchHistoricalData(String coinId) async {
    const days = 354;
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
    // This list will contain all fetched cryptocurrency data that matches our icons.
    List<dynamic> matchedCryptos = [];

    // Fetch all data at once.
    const String apiUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(response.body);

      // Filter out only the cryptocurrencies that we have icons for.
      for (var crypto in allData) {
        if (icons.keys.contains(crypto['name'])) {
          matchedCryptos.add(crypto);
        }
      }

      // Sort by the percentage change
      matchedCryptos.sort((a, b) =>
          b['price_change_percentage_24h'].compareTo(
              a['price_change_percentage_24h']));

      // Take top 2 gainers and top 2 losers
      List<dynamic> topGainers = matchedCryptos.take(2).toList();
      List<dynamic> topLosers = matchedCryptos.reversed.take(2).toList();

      // After filtering and sorting the data, print it to the console
      // print("Fetched cryptocurrency data:");
      // matchedCryptos.forEach((crypto) {
      //   print("${crypto['name']}: ${crypto['current_price']} (${crypto['price_change_percentage_24h']}%)");
      // });

      // Combine lists and update state
      if (mounted) {
        setState(() {
          cryptoData = [...topGainers, ...topLosers];
        });
      }
    } else {
      throw Exception('Failed to load crypto data');
    }
  }

  Widget cryptoCard(dynamic crypto) {
    return Card(
      elevation: 2.0, // Ajoute une petite ombre pour un effet 3D
      color: const Color(0xFF2A2D3E),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              crypto['name'],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text('\$${crypto['current_price'].toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white70),),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  crypto['price_change_percentage_24h'] >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: crypto['price_change_percentage_24h'] >= 0
                      ? Colors.green
                      : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  '${crypto['price_change_percentage_24h'].toStringAsFixed(
                      2)}%',
                  style: TextStyle(
                    color: crypto['price_change_percentage_24h'] >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cryptoData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.count(
      crossAxisCount: 4, // Nombre de colonnes
      crossAxisSpacing: 8, // Espace horizontal entre les cartes
      mainAxisSpacing: 8, // Espace vertical entre les cartes
      children: cryptoData.map((crypto) => cryptoCard(crypto)).toList(),
    );
  }
}