import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

enum TimePeriod { week, month, year }

class GraphPage extends StatefulWidget {
  final String cryptoId;
  final String cryptoName;
  final ImageProvider cryptoIconUrl;
  final List historicalData;

  const GraphPage({
    Key? key,
    required this.cryptoId,
    required this.cryptoName,
    required this.cryptoIconUrl,
    required this.historicalData,
  }) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  TimePeriod selectedPeriod = TimePeriod.month;

  @override
  void initState() {
    super.initState();
  }

  // Ajuster cette fonction pour retourner un seul spot par jour avec la valeur moyenne
  List<FlSpot> getSpotsFromData(TimePeriod period) {
    final now = DateTime.now();
    final dataCutOffTime = {
      TimePeriod.week: now.subtract(const Duration(days: 7)),
      TimePeriod.month: now.subtract(const Duration(days: 30)),
      TimePeriod.year: now.subtract(const Duration(days: 365)),
    }[period]!.millisecondsSinceEpoch;

    // Grouper les données par jour
    Map<int, List<double>> groupedData = {};
    for (var data in widget.historicalData.where((data) => data['timestamp'] >= dataCutOffTime)) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
      // Clé basée sur la date sans tenir compte de l'heure
      int dateKey = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;

      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = [];
      }
      groupedData[dateKey]!.add((data['price'] as num).toDouble());
    }

    // Calculer un seul spot par jour avec la valeur moyenne ou de clôture
    List<FlSpot> spots = [];
    groupedData.forEach((timestamp, prices) {
      double averagePrice = prices.reduce((a, b) => a + b) / prices.length;
      spots.add(FlSpot(timestamp.toDouble(), averagePrice));
    });

    // Tri par date
    spots.sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final spots = getSpotsFromData(selectedPeriod);
    final yValues = spots.map((spot) => spot.y).toList()..sort();
    final minYValue = yValues.first;
    final maxYValue = yValues.last;

    final filteredYValues = yValues.where((value) => value != minYValue && value != maxYValue).toList();
    final yStep = ((maxYValue - minYValue) / 9).clamp((maxYValue - minYValue) / 9, (maxYValue - minYValue) / 9);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cryptoName),
        leading: Image(image: widget.cryptoIconUrl),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: TimePeriod.values.map((period) => ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedPeriod = period;
                  });
                },
                child: Text(
                  period.toString().split('.').last.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedPeriod == period
                      ? Colors.deepPurple.withOpacity(0.8)
                      : Colors.black54.withOpacity(0.8),
                ),
              )).toList(),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(50.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,)
                      ),
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,)
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (maxYValue - minYValue) / 10,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                '\$${value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xff67727d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                          reservedSize: 80,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            String text = DateFormat('d MMM').format(date);

                            return Transform.rotate(
                              angle: -45 * 3.141592653589793 / 180,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    color: Color(0xff67727d),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: spots.first.x,
                    maxX: spots.last.x,
                    minY: filteredYValues.first * 0.9,
                    maxY: filteredYValues.last * 1.1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.deepPurple[600],
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.black,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItems: (touchedSpots) => touchedSpots.map((touchedSpot) {
                          return LineTooltipItem(
                            '${DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()))}\n\$${touchedSpot.y.toStringAsFixed(2)} USD',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
