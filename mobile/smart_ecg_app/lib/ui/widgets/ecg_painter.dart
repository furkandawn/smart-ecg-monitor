import 'package:flutter/material.dart';

class EcgPainter extends CustomPainter {
  final List<double> samples;

  EcgPainter({
    required this.samples,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    // 1. Draw background grid lines (Subtle medical style)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    
    // Draw 5 horizontal lines
    for (int i = 1; i < 5; i++) {
      double y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Auto-Scaling Logic: Find the range of the current samples
    double minVal = samples[0];
    double maxVal = samples[0];
    for (var s in samples) {
      if (s < minVal) minVal = s;
      if (s > maxVal) maxVal = s;
    }

    double range = maxVal - minVal;
    // If all values are the same (flatline), set a default range to avoid division by zero
    if (range < 0.0001) range = 1.0; 

    // 3. Setup Trace Paint
    final tracePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Calculate horizontal spacing
    final double stepX = size.width / (samples.length - 1);
    
    // Vertical padding so the wave doesn't touch the edges (15% of height)
    final double padding = size.height * 0.15;
    final double drawableHeight = size.height - (padding * 2);

    for (int i = 0; i < samples.length; i++) {
      double x = i * stepX;
      
      // Normalize the value to a 0.0 -> 1.0 range
      double normalized = (samples[i] - minVal) / range;
      
      // Convert to screen Y (Flutter 0 is top, so we subtract from height)
      // This centers the wave and applies the padding
      double y = size.height - (padding + (normalized * drawableHeight));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, tracePaint);
  }

  @override
  bool shouldRepaint(covariant EcgPainter oldDelegate) {
    // Repaint if the data length or content changes
    return oldDelegate.samples != samples;
  }
}