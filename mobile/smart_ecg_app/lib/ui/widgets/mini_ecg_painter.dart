import 'package:flutter/material.dart';

class MiniEcgPainter extends CustomPainter {
  final List<double> data;
  
  MiniEcgPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Auto-scale logic
    double minY = data.reduce((curr, next) => curr < next ? curr : next);
    double maxY = data.reduce((curr, next) => curr > next ? curr : next);
    
    // Prevent division by zero if flatline
    if ((maxY - minY).abs() < 0.0001) {
      maxY += 1.0;
      minY -= 1.0;
    }

    final double rangeY = maxY - minY;
    final double stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      // Normalize Y (0..1)
      final normalizedY = (data[i] - minY) / rangeY;
      // Flip Y because Canvas 0 is top
      final y = size.height * (1.0 - normalizedY);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}