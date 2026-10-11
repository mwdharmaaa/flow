import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/models/account_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/features/transactions/transaction_tile.dart';

class DashboardSummary extends StatelessWidget {
  final AppState state;
  final VoidCallback onAddRecord;
  final VoidCallback onSeeAllWallets;
  final VoidCallback onSeeAllDebts;
  final VoidCallback onSeeAllBudgets;
  final VoidCallback onSeeAllSavings;
  final VoidCallback onSeeAllRecurring;

  const DashboardSummary({
    super.key,
    required this.state,
    required this.onAddRecord,
    required this.onSeeAllWallets,
    required this.onSeeAllDebts,
    required this.onSeeAllBudgets,
    required this.onSeeAllSavings,
    required this.onSeeAllRecurring,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSubtle = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final bgElevated = isDark ? AppTheme.darkBgElevated : Colors.white;
    final borderSubtle = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF09090B) : Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBgElevated : const Color(0xFFFFF4EB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? borderSubtle : Colors.transparent),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, size: 14, color: Color(0xFFFF7A00)),
                        SizedBox(width: 4),
                        Text('0 days', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFF7A00))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBgElevated : AppTheme.border.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.notifications_none_rounded, size: 18, color: textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Two Column Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderSubtle),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total balance', style: TextStyle(fontSize: 11, color: textSubtle)),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(state.totalBalance, currency: state.currency),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 36, color: borderSubtle),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Budget left', style: TextStyle(fontSize: 11, color: textSubtle)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSeeAllBudgets,
                        child: Text(
                          state.budgets.isEmpty ? 'Set up a budget' : 'View budget',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Latest records
          _buildSectionHeader('Latest records', onAddRecord),
          const SizedBox(height: 8),
          if (state.transactions.isEmpty)
            _buildEmptyTile(
              icon: Icons.edit_outlined,
              title: 'No transactions yet',
              subtitle: 'Try typing "coffee 18k" in chat',
              buttonLabel: '+ Record',
              onTap: onAddRecord,
            )
          else
            ...state.transactions.take(5).map((tx) {
              final account = state.accounts.where((a) => a.id == tx.accountId).firstOrNull;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TransactionTile(
                  transaction: tx,
                  currency: state.currency,
                  isDark: isDark,
                  accountName: account?.name,
                  onDelete: () => _confirmDeleteTransaction(context, tx),
                ),
              );
            }),
          const SizedBox(height: 22),

          // Balances (Wallets)
          _buildSectionHeader('Balances', onSeeAllWallets, actionText: 'See all'),
          const SizedBox(height: 10),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.accounts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, idx) => _buildWalletCard(state.accounts[idx]),
            ),
          ),
          const SizedBox(height: 22),

          // Debts
          _buildSectionHeader('Debts', onSeeAllDebts),
          const SizedBox(height: 8),
          _buildEmptyTile(
            icon: Icons.people_outline_rounded,
            title: 'No debts yet',
            subtitle: 'Lending, borrowing or splitting with friends',
            buttonLabel: '+ Record',
            onTap: onSeeAllDebts,
          ),
          const SizedBox(height: 22),

          // Monthly budget
          _buildSectionHeader('Monthly budget', onSeeAllBudgets),
          const SizedBox(height: 8),
          _buildEmptyTile(
            icon: Icons.pie_chart_outline_rounded,
            title: 'No budget yet',
            subtitle: 'Spending limits per category',
            buttonLabel: '+ Create',
            onTap: onSeeAllBudgets,
          ),
          const SizedBox(height: 22),

          // Recurring bills
          _buildSectionHeader('Recurring bills', onSeeAllRecurring),
          const SizedBox(height: 8),
          _buildEmptyTile(
            icon: Icons.autorenew_rounded,
            title: 'No recurring bills yet',
            subtitle: 'Subscriptions, utilities and monthly payments',
            buttonLabel: '+ Manage',
            onTap: onSeeAllRecurring,
          ),
          const SizedBox(height: 22),

          // Savings (Goals)
          _buildSectionHeader('Savings', onSeeAllSavings),
          const SizedBox(height: 8),
          _buildEmptyTile(
            icon: Icons.track_changes_rounded,
            title: 'No savings goals yet',
            subtitle: 'An emergency fund, a trip or a down payment',
            buttonLabel: '+ Create',
            onTap: onSeeAllSavings,
          ),
          const SizedBox(height: 22),

          // Direct Export Data Feature (Standard & Unlocked)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Financial data exported locally')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F9FD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.file_download_outlined, size: 20, color: AppTheme.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Export Data (CSV / JSON)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        SizedBox(height: 2),
                        Text('Standard local export feature • 100% free', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 18, color: AppTheme.subtle),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // What we're watching
          const Text('What we\'re watching', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 6),
          const Text('Shows up after about a week of recording.', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
          const SizedBox(height: 18),

          // Bottom feedback card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppTheme.primary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('How do you like the new Flow?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Text('Send feedback', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTransaction(BuildContext context, TransactionModel tx) {
    final isDark = state.isDarkMode;
    final displayTitle = tx.note.isNotEmpty ? tx.note : tx.category;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkBgElevated : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Expense',
          style: TextStyle(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "$displayTitle" (${CurrencyFormatter.format(tx.amount, currency: state.currency)})?',
          style: TextStyle(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              state.deleteTransaction(tx.id);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.expense,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap, {String actionText = 'All'}) {
    final isDark = state.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    final isDark = state.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppTheme.darkBorderSubtle : Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkBgSurface : AppTheme.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(AccountModel account) {
    Color bg = const Color(0xFFF0FDF4); // mint
    Color iconColor = const Color(0xFF10B981);
    if (account.name.toLowerCase().contains('gopay')) {
      bg = const Color(0xFFFFF1F2);
      iconColor = const Color(0xFF00AED6);
    } else if (account.name.toLowerCase().contains('jago')) {
      bg = const Color(0xFFFFFBEB);
      iconColor = const Color(0xFFFF8B00);
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet, size: 12, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(account.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.format(account.balance, currency: state.currency),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
