import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';
import 'ecg_painter.dart';

class EcgEventChart extends ConsumerWidget {
  final List<double> samples;
  final double height;

  const EcgEventChart({
    super.key,
    required this.samples,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        // Optional: Add a subtle grid like a real ECG paper
        border: Border.all(color: Colors.white10),
      ),
      child: samples.isEmpty
          ? Center(
              child: Text(
                i18n.tr('no_waveform_snapshot'),
                style: const TextStyle(color: Colors.white70),
              ),
            )
          : ClipRect( // Ensures the drawing doesn't bleed out of the container
              child: CustomPaint(
                painter: EcgPainter(
                  samples: samples,
                ),
              ),
            ),
    );
  }
}