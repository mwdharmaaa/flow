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
  final VoidCallback? onDelete;
  final bool isDark;

  const BudgetCategoryTile({
    super.key,
    required this.category,
    required this.spent,
    required this.limit,
    required this.currency,
    this.icon = Icons.restaurant_rounded,
    this.iconBgColor = const Color(0xFF9E3615),
    this.onDelete,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final validLimit = limit;
    final validSpent = spent;
    final percent = validLimit > 0 ? (validSpent / validLimit).clamp(0.0, 1.0) : 0.0;
    final percentageInt = (percent * 100).toInt();

    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSubtle = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final progressBg = isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE8EEF8);

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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        CurrencyFormatter.format(validSpent, currency: currency),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: iconBgColor,
                        ),
                      ),
                      if (onDelete != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onDelete,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 17,
                            color: textSubtle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: progressBg,
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
                    style: TextStyle(fontSize: 11, color: textSubtle),
                  ),
                  Text(
                    '$percentageInt%',
                    style: TextStyle(fontSize: 11, color: textSubtle),
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
