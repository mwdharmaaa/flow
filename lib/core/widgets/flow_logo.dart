import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class FlowLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color waveColor;

  const FlowLogo({
    super.key,
    this.size = 30,
    this.backgroundColor,
    this.waveColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: FlowLogoPainter(
          backgroundColor: backgroundColor,
          waveColor: waveColor,
        ),
      ),
    );
  }
}

class FlowLogoPainter extends CustomPainter {
  final Color? backgroundColor;
  final Color waveColor;

  const FlowLogoPainter({
    this.backgroundColor,
    this.waveColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100.0;

    if (backgroundColor != null) {
      final bgPaint = Paint()
        ..color = backgroundColor!
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width * 0.48,
        bgPaint,
      );
    }

    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.5 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Upper wave: M 23 43 C 30 36.5, 43 36.5, 50 43 C 57 49.5, 70 49.5, 77 43
    final upperWave = Path()
      ..moveTo(23 * scale, 43 * scale)
      ..cubicTo(
        30 * scale,
        36.5 * scale,
        43 * scale,
        36.5 * scale,
        50 * scale,
        43 * scale,
      )
      ..cubicTo(
        57 * scale,
        49.5 * scale,
        70 * scale,
        49.5 * scale,
        77 * scale,
        43 * scale,
      );
    canvas.drawPath(upperWave, wavePaint);

    // Lower wave: M 23 57 C 30 50.5, 43 50.5, 50 57 C 57 63.5, 70 63.5, 77 57
    final lowerWave = Path()
      ..moveTo(23 * scale, 57 * scale)
      ..cubicTo(
        30 * scale,
        50.5 * scale,
        43 * scale,
        50.5 * scale,
        50 * scale,
        57 * scale,
      )
      ..cubicTo(
        57 * scale,
        63.5 * scale,
        70 * scale,
        63.5 * scale,
        77 * scale,
        57 * scale,
      );
    canvas.drawPath(lowerWave, wavePaint);
  }

  @override
  bool shouldRepaint(covariant FlowLogoPainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.waveColor != waveColor;
}
