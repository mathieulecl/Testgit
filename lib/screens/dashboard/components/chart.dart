import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key, required MaterialColor color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a random value for the gauge pointer
    final double randomValue = Random().nextDouble() * (85 - 70) + 70;

    // Create animated radial gauge.
    // All arguments changes will be automatically animated.
    return Column(
      children: [
        AnimatedRadialGauge(
          /// The animation duration.
          duration: const Duration(seconds: 1),
          curve: Curves.elasticOut,
          /// Define the radius.
          /// If you omit this value, the parent size will be used, if possible.
          radius: 100,
          /// Gauge value.
          value: randomValue,
          /// Optionally, you can configure your gauge, providing additional
          /// styles and transformers.
          axis: GaugeAxis(
            /// Provide the [min] and [max] value for the [value] argument.
            min: 0,
            max: 100,
            /// Render the gauge as a 180-degree arc.
            degrees: 180,
            /// Set the background color and axis thickness.
            style: const GaugeAxisStyle(
              thickness: 20,
              background: Colors.black,
              segmentSpacing: 4,
            ),
            /// Define the progress bar (optional).
            progressBar: const GaugeProgressBar.rounded(
              color: Colors.transparent, // Utilisation de la couleur transparente
            ),
            /// Define axis segments (optional).
            segments: [
              const GaugeSegment(
                from: 0,
                to: 33.3,
                color: Colors.red,
                cornerRadius: Radius.zero,
              ),
              const GaugeSegment(
                from: 33.3,
                to: 66.6,
                color: Colors.orange,
                cornerRadius: Radius.zero,
              ),
              const GaugeSegment(
                from: 66.6,
                to: 100,
                color: Colors.green,
                cornerRadius: Radius.zero,
              ),
            ],
          ),
        ),
        SizedBox(height: 5), // Espacement entre le graphe et le texte
        Padding(
          padding: EdgeInsets.only(top: 5), // Ajout de padding en haut
          child: Text(
            '${randomValue.toInt()}%', // Afficher la valeur en pourcentage
            style: TextStyle(
              color: Colors.white, // Couleur du texte en blanc
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}