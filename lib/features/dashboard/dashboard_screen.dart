import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/transactions/transaction_card.dart';
import 'package:flow/features/transactions/date_group_header.dart';
import 'package:flow/features/transactions/add_transaction_dialog.dart';
import 'package:flow/features/dashboard/sheet_month_year.dart';
import 'package:flow/models/transaction_model.dart';

class DashboardScreen extends StatefulWidget {
  final AppState state;

  const DashboardScreen({super.key, required this.state});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _openMonthYearPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SheetMonthYear(
        initialDate: _currentMonth,
        onSelect: (newMonth) {
          setState(() {
            _currentMonth = newMonth;
          });
        },
      ),
    );
  }

  void _openAddTransaction(BuildContext context, [TransactionType type = TransactionType.expense]) {
    showDialog(
      context: context,
      builder: (_) => AddTransactionDialog(
        accounts: widget.state.accounts,
        initialType: type,
        onSave: (tx) => widget.state.addTransaction(tx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    // Filter transactions for current month
    final monthTransactions = state.transactions.where((tx) {
      return tx.date.year == _currentMonth.year && tx.date.month == _currentMonth.month;
    }).toList();

    // Group transactions by date (Monee item_header_date structure)
    final Map<DateTime, List<TransactionModel>> groupedByDate = {};
    for (var tx in monthTransactions) {
      final key = DateTime(tx.date.year, tx.date.month, tx.date.day);
      groupedByDate.putIfAbsent(key, () => []).add(tx);
    }
    final sortedDates = groupedByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    final monthIncome = monthTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final monthExpense = monthTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final monthNet = monthIncome - monthExpense;
    final monthLabel = DateFormat('MMMM yyyy', 'id_ID').format(_currentMonth);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Month Selector Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white70),
                  onPressed: _previousMonth,
                ),
                GestureDetector(
                  onTap: _openMonthYearPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          monthLabel,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: AppTheme.primary, size: 18),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white70),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Monee Style Cash Flow Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  const Text('Total Saldo Bersih', style: TextStyle(fontSize: 12, color: AppTheme.subtle)),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.format(monthNet, currency: state.currency),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: monthNet >= 0 ? Colors.white : AppTheme.expense,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.border, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.income.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.south_west, size: 16, color: AppTheme.income),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pemasukan', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
                                  Text(
                                    CurrencyFormatter.format(monthIncome, currency: state.currency),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.income),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 32, color: AppTheme.border),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.expense.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.north_east, size: 16, color: AppTheme.expense),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pengeluaran', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
                                  Text(
                                    CurrencyFormatter.format(monthExpense, currency: state.currency),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.expense),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Transactions Header & List
            if (monthTransactions.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.card.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 40, color: AppTheme.subtle.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada transaksi di bulan ini',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ketuk tombol + di bawah untuk mencatat transaksi',
                      style: TextStyle(fontSize: 11, color: AppTheme.subtle),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else ...[
              for (var date in sortedDates) ...[
                Builder(
                  builder: (_) {
                    final dayTxs = groupedByDate[date]!;
                    final dayNet = dayTxs.fold(0.0, (sum, t) {
                      if (t.type == TransactionType.income) return sum + t.amount;
                      if (t.type == TransactionType.expense) return sum - t.amount;
                      return sum;
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DateGroupHeader(
                          date: date,
                          netAmount: dayNet,
                          currency: state.currency,
                        ),
                        ...dayTxs.map(
                          (tx) => TransactionCard(
                            transaction: tx,
                            accounts: state.accounts,
                            currency: state.currency,
                            onDelete: () => state.deleteTransaction(tx.id),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ],
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
