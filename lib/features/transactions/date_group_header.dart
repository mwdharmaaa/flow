import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';

class DateGroupHeader extends StatelessWidget {
  final DateTime date;
  final double netAmount;
  final String currency;

  const DateGroupHeader({
    super.key,
    required this.date,
    required this.netAmount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final dayNum = DateFormat('dd').format(date);
    final dayName = DateFormat('EEEE', 'id_ID').format(date);
    final monthYear = DateFormat('MMM yyyy', 'id_ID').format(date);

    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.cardHover,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  dayNum,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    monthYear,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.subtle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            CurrencyFormatter.format(netAmount, currency: currency),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: netAmount > 0
                  ? AppTheme.income
                  : netAmount < 0
                      ? AppTheme.expense
                      : AppTheme.subtle,
            ),
          ),
        ],
      ),
    );
  }
}
