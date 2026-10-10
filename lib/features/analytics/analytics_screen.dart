import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/models/transaction_model.dart';

class AnalyticsScreen extends StatelessWidget {
  final AppState state;

  const AnalyticsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final expenses = state.transactions.where((t) => t.type == TransactionType.expense).toList();
    final totalExpense = state.totalExpense;

    final Map<String, double> categoryTotals = {};
    for (var tx in expenses) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0.0) + tx.amount;
    }

    final sorted = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      AppTheme.expense,
      AppTheme.primary,
      AppTheme.transfer,
      AppTheme.warning,
      AppTheme.income,
      const Color(0xFF06B6D4),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bar_chart, size: 20, color: AppTheme.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Analitik & Laporan Mendalam', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('Fitur Bebas Tanpa Paywall • 100% Offline', style: TextStyle(fontSize: 10, color: AppTheme.subtle)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PERBANDINGAN ARUS KAS', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFlowBar('Masuk', state.totalIncome, AppTheme.income),
                      _buildFlowBar('Keluar', state.totalExpense, AppTheme.expense),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'DISTRIBUSI PENGELUARAN PER KATEGORI',
              style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),
            if (sorted.isEmpty)
              const Center(child: Text('Belum ada data pengeluaran.', style: TextStyle(fontSize: 12, color: AppTheme.subtle)))
            else
              ...List.generate(sorted.length, (idx) {
                final entry = sorted[idx];
                final percent = totalExpense > 0 ? (entry.value / totalExpense) : 0.0;
                final color = colors[idx % colors.length];

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
                              Text(entry.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                          Text(
                            '${(percent * 100).toStringAsFixed(1)}% • ${CurrencyFormatter.format(entry.value, currency: state.currency)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
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

  Widget _buildFlowBar(String label, double amount, Color color) {
    return Column(
      children: [
        Text(CurrencyFormatter.format(amount, currency: state.currency), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        Container(width: 36, height: 60, decoration: BoxDecoration(color: color.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(8))),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.subtle)),
      ],
    );
  }
}
