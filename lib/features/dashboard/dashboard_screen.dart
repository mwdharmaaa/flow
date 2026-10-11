import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/dashboard/dashboard_hero.dart';
import 'package:flow/features/dashboard/dashboard_summary.dart';
import 'package:flow/features/transactions/add_transaction_dialog.dart';
import 'package:flow/features/transactions/log_options_modal.dart';
import 'package:flow/models/transaction_model.dart';

class DashboardScreen extends StatefulWidget {
  final AppState state;

  const DashboardScreen({super.key, required this.state});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  void _openAddTransaction(BuildContext context) {
    LogOptionsModal.show(context, widget.state);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final state = widget.state;

        // Filter transactions for current month
        final monthTransactions = state.transactions.where((tx) {
          return tx.date.year == _currentMonth.year && tx.date.month == _currentMonth.month;
        }).toList();

        final monthExpense = monthTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        final isDark = state.isDarkMode;

        return Container(
          color: isDark ? const Color(0xFF09090B) : Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DashboardHero(
                  monthExpense: monthExpense,
                  currency: state.currency,
                  currentMonth: _currentMonth,
                  onAddTransaction: () => _openAddTransaction(context),
                  state: state,
                ),
                DashboardSummary(
                  state: state,
                  onAddRecord: () => _openAddTransaction(context),
                  onSeeAllWallets: () => state.setTabIndex(3),
                  onSeeAllBudgets: () => state.setTabIndex(2),
                  onSeeAllDebts: () => state.setTabIndex(4),
                  onSeeAllRecurring: () => state.setTabIndex(5),
                  onSeeAllSavings: () => state.setTabIndex(6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
