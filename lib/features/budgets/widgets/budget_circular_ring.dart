import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';

class BudgetCircularRing extends StatelessWidget {
  final double spent;
  final double limit;
  final String currency;

  const BudgetCircularRing({
    super.key,
    required this.spent,
    required this.limit,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final validLimit = limit > 0 ? limit : 200000.0;
    final validSpent = spent > 0 ? spent : 15000.0;
    final percentage = (validSpent / validLimit * 100).clamp(0, 100).toInt();
    final remaining = (validLimit - validSpent).clamp(0.0, double.infinity);
    final daysLeft = math.max(1, 31 - DateTime.now().day);
    final perDay = remaining / daysLeft;

    return Column(
      children: [
        // Circular Ring
        SizedBox(
          width: 170,
          height: 170,
          child: CustomPaint(
            painter: RingPainter(
              progress: validSpent / validLimit,
              ringColor: const Color(0xFFE8EEF8),
              progressColor: AppTheme.primary,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Text(
                    'used',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.subtle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Spent / Limit Text
        Text(
          CurrencyFormatter.format(validSpent, currency: currency),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '/ ${CurrencyFormatter.format(validLimit, currency: currency)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.subtle,
          ),
        ),
        const SizedBox(height: 12),

        // On Track Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: AppTheme.subtle, height: 1.4),
              children: [
                const TextSpan(
                  text: 'On track. ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                ),
                TextSpan(
                  text: '${CurrencyFormatter.format(remaining, currency: currency)} left is enough for ${CurrencyFormatter.format(perDay, currency: currency)}/day until the end of the month.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color progressColor;

  RingPainter({
    required this.progress,
    required this.ringColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;

    // Background track
    final bgPaint = Paint()
      ..color = ringColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Active progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (progress.clamp(0.0, 1.0)) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
