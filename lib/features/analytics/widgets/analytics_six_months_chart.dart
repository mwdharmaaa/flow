import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';

class AnalyticsSixMonthsChart extends StatelessWidget {
  final double incomeOct;
  final double expenseOct;
  final String currency;
  final bool isDark;

  const AnalyticsSixMonthsChart({
    super.key,
    required this.incomeOct,
    required this.expenseOct,
    required this.currency,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    const months = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last 6 months',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Legend Row
        Row(
          children: [
            Container(
              width: 14,
              height: 3,
              color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text('Income', style: TextStyle(fontSize: 12, color: textSecondary)),
            const SizedBox(width: 16),
            Container(width: 14, height: 3, color: const Color(0xFFE85934)),
            const SizedBox(width: 6),
            Text('Expenses', style: TextStyle(fontSize: 12, color: textSecondary)),
          ],
        ),
        const SizedBox(height: 6),

        // Subtitle
        Text(
          'Oct (in progress) • in ${CurrencyFormatter.format(incomeOct, currency: currency)} • out ${CurrencyFormatter.format(expenseOct, currency: currency)}',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 20),

        // 6-Month Line Chart
        SizedBox(
          height: 140,
          child: CustomPaint(
            size: const Size(double.infinity, 140),
            painter: SixMonthsChartPainter(
              hasExpense: expenseOct > 0,
              isDark: isDark,
            ),
          ),
        ),

        // Month Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: months.map((m) {
            final isCurrent = m == 'Oct';
            return Text(
              m,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? textPrimary : textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SixMonthsChartPainter extends CustomPainter {
  final bool hasExpense;
  final bool isDark;

  SixMonthsChartPainter({required this.hasExpense, this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - 20;

    final xSteps = [
      w * 0.05,
      w * 0.23,
      w * 0.41,
      w * 0.59,
      w * 0.77,
      w * 0.95,
    ];

    final baseY = h;

    // Draw Blue Income Line (flat along base)
    final bluePaint = Paint()
      ..color = isDark ? AppTheme.darkAccentPrimary : const Color(0xFF1D61E0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(xSteps[4], baseY), Offset(xSteps[5], baseY), bluePaint);

    // Draw Orange Expense Line
    final orangeColor = isDark ? const Color(0xFFFF6E4A) : const Color(0xFFE85934);
    final orangePaint = Paint()
      ..color = orangeColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final octY = hasExpense ? 20.0 : baseY;

    final path = Path();
    path.moveTo(xSteps[0], baseY);
    path.lineTo(xSteps[1], baseY);
    path.lineTo(xSteps[2], baseY);
    path.lineTo(xSteps[3], baseY);
    path.lineTo(xSteps[4], baseY);
    path.lineTo(xSteps[5], octY);
    canvas.drawPath(path, orangePaint);

    // Draw Orange Dots
    final dotPaint = Paint()..color = orangeColor;
    final dotWhite = Paint()..color = isDark ? const Color(0xFF16161F) : Colors.white;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(xSteps[i], baseY), 4.5, dotPaint);
      canvas.drawCircle(Offset(xSteps[i], baseY), 2.5, dotWhite);
    }
    // High dot on Oct
    canvas.drawCircle(Offset(xSteps[5], octY), hasExpense ? 6.5 : 4.5, dotPaint);
    if (!hasExpense) {
      canvas.drawCircle(Offset(xSteps[5], octY), 2.5, dotWhite);
    }
  }

  @override
  bool shouldRepaint(covariant SixMonthsChartPainter oldDelegate) =>
      oldDelegate.hasExpense != hasExpense || oldDelegate.isDark != isDark;
}
