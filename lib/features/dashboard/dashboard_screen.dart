import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/dashboard/balance_card.dart';
import 'package:flow/features/dashboard/cash_flow_card.dart';
import 'package:flow/features/dashboard/quick_actions_grid.dart';
import 'package:flow/features/transactions/transaction_card.dart';
import 'package:flow/features/transactions/add_transaction_dialog.dart';
import 'package:flow/models/transaction_model.dart';

class DashboardScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onNavigateToTransactions;
  final VoidCallback onNavigateToAnalytics;
  final VoidCallback onNavigateToDebts;
  final VoidCallback onNavigateToRecurring;

  const DashboardScreen({
    super.key,
    required this.state,
    required this.onNavigateToTransactions,
    required this.onNavigateToAnalytics,
    required this.onNavigateToDebts,
    required this.onNavigateToRecurring,
  });

  void _openAddTransaction(BuildContext context, [TransactionType type = TransactionType.expense]) {
    showDialog(
      context: context,
      builder: (_) => AddTransactionDialog(
        accounts: state.accounts,
        initialType: type,
        onSave: (tx) => state.addTransaction(tx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentTransactions = state.transactions.take(5).toList();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceCard(
              totalBalance: state.totalBalance,
              accountsCount: state.accounts.length,
              currency: state.currency,
            ),
            const SizedBox(height: 16),
            CashFlowCard(
              income: state.totalIncome,
              expense: state.totalExpense,
              currency: state.currency,
            ),
            const SizedBox(height: 20),
            QuickActionsGrid(
              onTransfer: () => _openAddTransaction(context, TransactionType.transfer),
              onAnalytics: onNavigateToAnalytics,
              onDebts: onNavigateToDebts,
              onRecurring: onNavigateToRecurring,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TRANSAKSI TERAKHIR',
                  style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                GestureDetector(
                  onTap: onNavigateToTransactions,
                  child: const Row(
                    children: [
                      Text('Lihat Semua', style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (recentTransactions.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
                ),
                child: const Center(
                  child: Text('Belum ada transaksi.', style: TextStyle(fontSize: 12, color: AppTheme.subtle)),
                ),
              )
            else
              ...recentTransactions.map(
                (tx) => TransactionCard(
                  transaction: tx,
                  accounts: state.accounts,
                  currency: state.currency,
                  onDelete: () => state.deleteTransaction(tx.id),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => _openAddTransaction(context, TransactionType.expense),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
