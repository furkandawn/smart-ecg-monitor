import 'package:flutter/material.dart';
import 'ecg_painter.dart';

class LiveEcgChart extends StatelessWidget {
  final List<double> samples;
  final double gain;

  const LiveEcgChart({
    super.key,
    required this.samples,
    required this.gain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: EcgPainter(
          samples: samples,
          //gain: gain,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}