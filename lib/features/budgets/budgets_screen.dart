import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/budgets/add_budget_dialog.dart';

class BudgetsScreen extends StatelessWidget {
  final AppState state;

  const BudgetsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalLimit = state.budgets.fold(0.0, (sum, b) => sum + b.monthlyLimit);
    final totalSpent = state.budgets.fold(0.0, (sum, b) => sum + b.spent);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Batas Anggaran', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(totalLimit, currency: state.currency),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Terpakai: ${CurrencyFormatter.format(totalSpent, currency: state.currency)}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AddBudgetDialog(onSave: (bgt) => state.addBudget(bgt)),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'KATEGORI ANGGARAN (${state.budgets.length})',
              style: const TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: state.budgets.length,
                itemBuilder: (_, idx) {
                  final b = state.budgets[idx];
                  final percent = (b.spent / b.monthlyLimit).clamp(0.0, 1.0);
                  final isOver = b.spent > b.monthlyLimit;

                  final progressColor = isOver
                      ? AppTheme.expense
                      : percent > 0.7
                          ? AppTheme.warning
                          : AppTheme.income;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(b.category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(
                              isOver ? 'Over Budget' : 'Sisa ${CurrencyFormatter.format(b.monthlyLimit - b.spent, currency: state.currency)}',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: progressColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percent,
                            backgroundColor: AppTheme.surface,
                            valueColor: AlwaysStoppedAnimation(progressColor),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Terpakai: ${CurrencyFormatter.format(b.spent, currency: state.currency)}', style: const TextStyle(fontSize: 10, color: AppTheme.subtle)),
                            Text('Batas: ${CurrencyFormatter.format(b.monthlyLimit, currency: state.currency)}', style: const TextStyle(fontSize: 10, color: AppTheme.subtle)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
