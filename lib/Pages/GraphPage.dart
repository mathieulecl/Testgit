import 'dart:math';
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
  List<FlSpot> spots = [];
  TimePeriod selectedPeriod = TimePeriod.week;

  @override
  void initState() {
    super.initState();
    updateSpots(selectedPeriod);
  }

  void updateSpots(TimePeriod period) {
    final now = DateTime.now();
    final dataCutOffTime = {
      TimePeriod.week: now.subtract(Duration(days: 7)),
      TimePeriod.month: now.subtract(Duration(days: 30)),
      TimePeriod.year: now.subtract(Duration(days: 365)),
    }[period]!.millisecondsSinceEpoch;

    setState(() {
      selectedPeriod = period;
      spots = widget.historicalData
          .where((data) => data['timestamp'] >= dataCutOffTime)
          .map((data) => FlSpot(
        (data['timestamp'] as int).toDouble(),
        (data['price'] as num).toDouble(),
      ))
          .toList();
    });
  }

  String getTitle(double value, TimePeriod period) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return DateFormat('MM/dd/yyyy').format(date); // Adjusted to your required date format
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cryptoName),
        leading: Image(image: widget.cryptoIconUrl),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Buttons for TimePeriod selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: TimePeriod.values.map((period) => ElevatedButton(
                onPressed: () => updateSpots(period),
                child: Text(
                  period.toString().split('.').last.toUpperCase(),
                  style: TextStyle(color: Colors.white), // Text color is white for better visibility
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: selectedPeriod == period ? Colors.black.withOpacity(0.8) : Colors.black54.withOpacity(0.8), // This is the text color
                ),
              )).toList(),
            ),
            SizedBox(height: 6), // For some spacing
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(50.0), // Add padding around the chart
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Define the border color and width
                  borderRadius: BorderRadius.circular(10), // Optional, if you want rounded corners
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                        showTitles: true,
                        interval: (spots.map((spot) => spot.y).reduce(max) - spots.map((spot) => spot.y).reduce(min)) / 10,
                        getTitles: (value) {
                          return '\$${value.toStringAsFixed(2)}'; // Display the price in dollars
                        },
                        reservedSize: 60, // To ensure there's enough space for the labels
                        getTextStyles: (context, value) => const TextStyle(
                          color: Color(0xff67727d),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        margin: 10,
                      ),
                      bottomTitles: SideTitles(
                        showTitles: false,
                        getTitles: (value) {
                          return getTitle(value, selectedPeriod); // This will format the bottom titles
                        },
                        reservedSize: 22,
                        margin: 10,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: spots.first.x,
                    maxX: spots.last.x,
                    minY: spots.map((spot) => spot.y).reduce(min) * 0.9,
                    maxY: spots.map((spot) => spot.y).reduce(max) * 1.1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        colors: [Colors.deepPurple],
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
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final textStyle = TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                            return LineTooltipItem(
                              '${DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()))}\n\$${touchedSpot.y.toStringAsFixed(2)} USD',
                              textStyle,
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (LineTouchResponse touchResponse) {},
                      handleBuiltInTouches: true,
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}