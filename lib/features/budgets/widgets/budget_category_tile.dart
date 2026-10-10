import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';

class BudgetCategoryTile extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;
  final String currency;
  final IconData icon;
  final Color iconBgColor;

  const BudgetCategoryTile({
    super.key,
    required this.category,
    required this.spent,
    required this.limit,
    required this.currency,
    this.icon = Icons.restaurant_rounded,
    this.iconBgColor = const Color(0xFF9E3615),
  });

  @override
  Widget build(BuildContext context) {
    final validLimit = limit;
    final validSpent = spent;
    final percent = validLimit > 0 ? (validSpent / validLimit).clamp(0.0, 1.0) : 0.0;
    final percentageInt = (percent * 100).toInt();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(validSpent, currency: currency),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: iconBgColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: const Color(0xFFE8EEF8),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget ${CurrencyFormatter.format(validLimit, currency: currency)}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                  ),
                  Text(
                    '$percentageInt%',
                    style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
