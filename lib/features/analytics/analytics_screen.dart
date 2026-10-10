import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/models/transaction_model.dart';

class AnalyticsScreen extends StatefulWidget {
  final AppState state;

  const AnalyticsScreen({super.key, required this.state});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TransactionType _selectedType = TransactionType.expense;

  static const List<Color> _categoryColors = [
    AppTheme.primary,
    Color(0xFFF43F5E),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
  ];

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isExpense = _selectedType == TransactionType.expense;
    final txs = state.transactions.where((t) => t.type == _selectedType).toList();
    final totalAmount = isExpense ? state.totalExpense : state.totalIncome;

    final Map<String, double> categoryTotals = {};
    for (var tx in txs) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0.0) + tx.amount;
    }
    final sorted = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monee Style Tab Switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleTab(
                      TransactionType.expense,
                      'Pengeluaran',
                      AppTheme.expense,
                    ),
                  ),
                  Expanded(
                    child: _buildToggleTab(
                      TransactionType.income,
                      'Pemasukan',
                      AppTheme.income,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExpense ? 'Total Pengeluaran Tercatat' : 'Total Pemasukan Tercatat',
                    style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.format(totalAmount, currency: state.currency),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isExpense ? AppTheme.expense : AppTheme.income,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'DISTRIBUSI KATEGORI (${sorted.length})',
              style: const TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),

            if (sorted.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.card.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: Text(
                    'Belum ada transaksi ${isExpense ? 'pengeluaran' : 'pemasukan'}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.subtle),
                  ),
                ),
              )
            else
              ...List.generate(sorted.length, (idx) {
                final entry = sorted[idx];
                final percent = totalAmount > 0 ? (entry.value / totalAmount) : 0.0;
                final color = _categoryColors[idx % _categoryColors.length];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text(entry.key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                          Text(
                            '${(percent * 100).toStringAsFixed(1)}% • ${CurrencyFormatter.format(entry.value, currency: state.currency)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: AppTheme.surface,
                          valueColor: AlwaysStoppedAnimation(color),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTab(TransactionType type, String label, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: color, width: 1) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppTheme.subtle,
          ),
        ),
      ),
    );
  }
}
