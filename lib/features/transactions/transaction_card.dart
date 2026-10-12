import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/widgets/liquid_glass_container.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/account_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final List<AccountModel> accounts;
  final String currency;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.accounts,
    required this.currency,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant;
      case 'Belanja':
        return Icons.shopping_bag;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Tagihan':
        return Icons.receipt;
      case 'Hiburan':
        return Icons.movie;
      case 'Kesehatan':
        return Icons.local_hospital;
      case 'Pendidikan':
        return Icons.school;
      case 'Gaji':
        return Icons.payments;
      case 'Investasi':
        return Icons.trending_up;
      case 'Transfer':
      case 'Transfer Saldo':
        return Icons.swap_horiz;
      default:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(String category, TransactionType type) {
    if (type == TransactionType.transfer) return AppTheme.transfer;
    if (type == TransactionType.income) return AppTheme.income;

    switch (category) {
      case 'Makanan':
        return const Color(0xFFF43F5E);
      case 'Belanja':
        return const Color(0xFFEC4899);
      case 'Transportasi':
        return const Color(0xFF3B82F6);
      case 'Tagihan':
        return const Color(0xFFEAB308);
      case 'Hiburan':
        return const Color(0xFF8B5CF6);
      case 'Kesehatan':
        return const Color(0xFF10B981);
      default:
        return AppTheme.subtle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = accounts.firstWhere(
      (a) => a.id == transaction.accountId,
      orElse: () => AccountModel(id: '', name: 'Dompet', type: 'cash', balance: 0, colorValue: 0xFF3B82F6),
    );

    final destAccount = transaction.destinationAccountId != null
        ? accounts.firstWhere(
            (a) => a.id == transaction.destinationAccountId,
            orElse: () => AccountModel(id: '', name: 'Tujuan', type: 'cash', balance: 0, colorValue: 0xFF3B82F6),
          )
        : null;

    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;
    final color = _getCategoryColor(transaction.category, transaction.type);
    final icon = _getCategoryIcon(transaction.category);

    final subtitle = destAccount != null
        ? '${account.name} → ${destAccount.name}'
        : transaction.note.isNotEmpty
            ? '${account.name} • ${transaction.note}'
            : account.name;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;

    return LiquidGlassContainer(
      isDark: isDark,
      radius: 18,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: titleColor),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : isIncome ? '+' : ''}${CurrencyFormatter.format(transaction.amount, currency: currency)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isExpense ? AppTheme.expense : isIncome ? AppTheme.income : AppTheme.transfer,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.formatDate(transaction.date),
                style: const TextStyle(fontSize: 10, color: AppTheme.subtle),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.subtle),
            padding: const EdgeInsets.only(left: 8),
            constraints: const BoxConstraints(),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
