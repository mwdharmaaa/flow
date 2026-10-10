import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final VoidCallback onDelete;
  final bool isDark;
  final String? accountName;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currency,
    required this.onDelete,
    this.isDark = false,
    this.accountName,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'bills':
        return Icons.receipt_long_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'health':
        return Icons.medical_services_outlined;
      case 'education':
        return Icons.school_outlined;
      case 'salary':
      case 'income':
        return Icons.payments_outlined;
      default:
        return Icons.credit_card_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSubtle = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final bgElevated = isDark ? AppTheme.darkBgElevated : Colors.white;
    final borderSubtle = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;

    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;

    final amountColor = isExpense
        ? AppTheme.expense
        : isIncome
            ? AppTheme.income
            : (isDark ? AppTheme.darkAccentPrimary : AppTheme.primary);

    final amountPrefix = isExpense ? '-' : (isIncome ? '+' : '');
    final dateStr = DateFormat('d MMM', 'en_US').format(transaction.date);
    final displayTitle = transaction.note.isNotEmpty ? transaction.note : transaction.category;
    final subtitleText = accountName != null ? '${transaction.category} • $accountName • $dateStr' : '${transaction.category} • $dateStr';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isExpense
                  ? (isDark ? const Color(0xFF2E1A1A) : const Color(0xFFFEE2E2))
                  : (isDark ? const Color(0xFF162B1D) : const Color(0xFFDCFCE7)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              size: 20,
              color: isExpense ? AppTheme.expense : AppTheme.income,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitleText,
                  style: TextStyle(fontSize: 11, color: textSubtle),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix ${CurrencyFormatter.format(transaction.amount, currency: currency)}',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: amountColor),
              ),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.delete_outline_rounded, size: 18, color: textSubtle),
            ),
          ),
        ],
      ),
    );
  }
}
