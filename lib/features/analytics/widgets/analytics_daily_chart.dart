import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';

class AnalyticsDailyChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String currency;
  final DateTime currentMonth;

  const AnalyticsDailyChart({
    super.key,
    required this.transactions,
    required this.currency,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayLabel = DateFormat('EEE, d MMM', 'en_US').format(now);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    // Calculate spend per day of this month
    final Map<int, double> dailySpend = {};
    for (var tx in transactions) {
      if (tx.type == TransactionType.expense &&
          tx.date.year == currentMonth.year &&
          tx.date.month == currentMonth.month) {
        dailySpend[tx.date.day] = (dailySpend[tx.date.day] ?? 0.0) + tx.amount;
      }
    }

    final totalSpent = dailySpend.values.fold(0.0, (sum, v) => sum + v);
    final maxSpent = dailySpend.values.isNotEmpty
        ? dailySpend.values.reduce((a, b) => a > b ? a : b)
        : 10000.0;
    final chartMax = maxSpent > 0 ? maxSpent : 10000.0;

    final todaySpent = dailySpend[now.day] ?? 0.0;
    final activeDay = now.day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily trend',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$dayLabel • ${CurrencyFormatter.format(todaySpent, currency: currency)}',
          style: const TextStyle(fontSize: 13, color: AppTheme.subtle),
        ),
        const SizedBox(height: 18),

        // 31-Day Bar Chart Container
        Container(
          height: 140,
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Stack(
            children: [
              // Horizontal dotted average guide line
              Positioned(
                left: 0,
                right: 0,
                bottom: 45,
                child: CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: DottedLinePainter(color: const Color(0xFFC8D7ED)),
                ),
              ),

              // Bars
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(daysInMonth, (i) {
                  final day = i + 1;
                  final amount = dailySpend[day] ?? 0.0;

                  final barHeight = (amount / chartMax * 75).clamp(amount > 0 ? 8.0 : 0.0, 75.0);
                  final isActive = day == activeDay;

                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / daysInMonth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (amount > 0)
                          Container(
                            width: 6,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                        else
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2EBF6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // X-Axis Labels (1, 5, 10, 15, 20, 25, 31)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [1, 5, 10, 15, 20, 25, 31].map((d) {
            final isHighlight = d == activeDay || (activeDay <= 12 && d == 10);
            return Text(
              '$d',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? AppTheme.primary : AppTheme.subtle,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        // Legend Row below Chart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '---- avg ${CurrencyFormatter.format(totalSpent > 0 ? (totalSpent / daysInMonth) : 0.0, currency: currency)}/day',
              style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
            ),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FA7EC),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'above average',
                  style: TextStyle(fontSize: 11, color: AppTheme.subtle),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
