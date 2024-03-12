import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatelessWidget {
  final List<Map<String, dynamic>> historicalData;
  final String cryptoName;
  final AssetImage cryptoIcon;

  GraphPage({
    Key? key,
    required this.historicalData,
    required this.cryptoName,
    required this.cryptoIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    if (historicalData.isNotEmpty) {
      DateTime startDate = DateTime.parse(historicalData.first['date']);
      for (var dataPoint in historicalData) {
        DateTime date = DateTime.parse(dataPoint['date']);
        double price = dataPoint['price_usd'];
        minY = price < minY ? price : minY;
        maxY = price > maxY ? price : maxY;
        double daysSinceStart = date.difference(startDate).inDays.toDouble();
        spots.add(FlSpot(daysSinceStart, price));
      }
    }

    double yAxisInterval = ((maxY - minY) / 10).ceilToDouble();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image(image: cryptoIcon, height: 20),
            SizedBox(width: 8),
            Text(cryptoName),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: spots.last.x,
              minY: minY - (yAxisInterval),
              maxY: maxY + (yAxisInterval),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10),
                  getTitles: (value) {
                    return DateFormat('MM/dd').format(DateTime.now().add(Duration(days: value.toInt())));
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  interval: yAxisInterval,
                  getTextStyles: (context, value) => const TextStyle(
                    color: Colors.blue,
                    fontSize: 8,
                  ),
                  getTitles: (value) {
                    String text;
                    if (value >= 1000) {
                      text = '\$${(value / 1000).toStringAsFixed(1)}k';
                    } else {
                      text = '\$${value.toStringAsFixed(2)}';
                    }
                    return text;
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  colors: [
                    Colors.deepPurpleAccent,
                  ],
                  barWidth: 5,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [
                      Colors.deepPurpleAccent.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    gradientFrom: Offset(0, 0),
                    gradientTo: Offset(0, 1),
                  ),
                ),
              ],
              clipData: FlClipData.all(),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                ),
                touchCallback: (LineTouchResponse touchResponse) {},
                handleBuiltInTouches: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

