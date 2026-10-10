import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
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

  @override
  Widget build(BuildContext context) {
    final account = accounts.firstWhere(
      (a) => a.id == transaction.accountId,
      orElse: () => AccountModel(id: '', name: 'Akun', type: 'cash', balance: 0, colorValue: 0xFF3B82F6),
    );

    final destAccount = transaction.destinationAccountId != null
        ? accounts.firstWhere(
            (a) => a.id == transaction.destinationAccountId,
            orElse: () => AccountModel(id: '', name: 'Akun Tujuan', type: 'cash', balance: 0, colorValue: 0xFF3B82F6),
          )
        : null;

    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;

    final iconColor = isExpense
        ? AppTheme.expense
        : isIncome
            ? AppTheme.income
            : AppTheme.transfer;

    final iconData = isExpense
        ? Icons.arrow_outward
        : isIncome
            ? Icons.arrow_downward
            : Icons.swap_horiz;

    final subtitle = destAccount != null
        ? '${account.name} → ${destAccount.name} • ${CurrencyFormatter.formatDate(transaction.date)}'
        : '${account.name} • ${CurrencyFormatter.formatDate(transaction.date)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                ),
                if (transaction.note.isNotEmpty)
                  Text(
                    transaction.note,
                    style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.white60),
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
                  color: iconColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.subtle),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
