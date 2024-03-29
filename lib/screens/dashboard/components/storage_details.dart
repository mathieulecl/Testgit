import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Storage Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          // Ajout du widget du diagramme en camembert
          AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 30,
                    title: '30%',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: 20,
                    title: '20%',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 50,
                    title: '50%',
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: defaultPadding * 2), // Espacement supplémentaire
          // Ajout du widget du graphique de capitalisation boursière
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                // Données de votre graphique (à remplacer par vos propres données)
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(1, 4),
                      FlSpot(2, 3.5),
                      FlSpot(3, 5),
                      FlSpot(4, 4),
                      FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minY: 0,
                titlesData: FlTitlesData(
                  show: false,
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
