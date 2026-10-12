import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/widgets/liquid_background.dart';
import 'package:flow/core/widgets/liquid_glass_container.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/models/debt_model.dart';

class DebtsScreen extends StatelessWidget {
  final AppState state;

  const DebtsScreen({super.key, required this.state});

  void _openAddDebtDialog(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String type = 'receivable';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: state.isDarkMode ? AppTheme.darkBgElevated : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius(state.isDarkMode, 24)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Log Debt / Loan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: state.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'receivable'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: type == 'receivable' ? AppTheme.income.withValues(alpha: 0.12) : (state.isDarkMode ? AppTheme.darkBgSurface : const Color(0xFFF6F9FD)),
                            borderRadius: AppTheme.borderRadius(state.isDarkMode, 10),
                            border: Border.all(color: type == 'receivable' ? AppTheme.income : (state.isDarkMode ? AppTheme.darkBorderSubtle : AppTheme.border)),
                          ),
                          alignment: Alignment.center,
                          child: Text('Lent to (Owed)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: type == 'receivable' ? AppTheme.income : AppTheme.subtle)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'payable'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: type == 'payable' ? AppTheme.expense.withValues(alpha: 0.12) : (state.isDarkMode ? AppTheme.darkBgSurface : const Color(0xFFF6F9FD)),
                            borderRadius: AppTheme.borderRadius(state.isDarkMode, 10),
                            border: Border.all(color: type == 'payable' ? AppTheme.expense : (state.isDarkMode ? AppTheme.darkBorderSubtle : AppTheme.border)),
                          ),
                          alignment: Alignment.center,
                          child: Text('Borrowed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: type == 'payable' ? AppTheme.expense : AppTheme.subtle)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Contact / Person Name', filled: true, fillColor: Color(0xFFF6F9FD)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(labelText: 'Amount (Rp)', filled: true, fillColor: Color(0xFFF6F9FD)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Note (Optional)', filled: true, fillColor: Color(0xFFF6F9FD)),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                    if (nameController.text.trim().isEmpty || amount <= 0) return;
                    state.addDebt(DebtModel(
                      id: 'debt_${DateTime.now().millisecondsSinceEpoch}',
                      type: type,
                      personName: nameController.text.trim(),
                      amount: amount,
                      remainingAmount: amount,
                      dueDate: DateTime.now().add(const Duration(days: 14)),
                      note: noteController.text.trim(),
                    ));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                  child: const Text('Save Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBgBase : AppTheme.background,
      body: LiquidBackground(
        isDark: isDark,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('DEBT CONTACTS', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _openAddDebtDialog(context),
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: state.debts.isEmpty
                  ? const Center(child: Text('No debt records yet.', style: TextStyle(fontSize: 13, color: AppTheme.subtle)))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 110),
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 300,
                      itemCount: state.debts.length,
                      itemBuilder: (_, idx) {
                        final d = state.debts[idx];
                        final isReceivable = d.type == 'receivable';
                        return LiquidGlassContainer(
                          isDark: isDark,
                          radius: 18,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(isReceivable ? Icons.call_made : Icons.call_received, color: isReceivable ? AppTheme.income : AppTheme.expense, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d.personName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: state.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary)),
                                    Text(isReceivable ? 'Lent' : 'Borrowed', style: TextStyle(fontSize: 10, color: isReceivable ? AppTheme.income : AppTheme.expense)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(d.amount, currency: state.currency),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isReceivable ? AppTheme.income : AppTheme.expense),
                                  ),
                                  if (!d.isSettled)
                                    TextButton(
                                      onPressed: () => state.settleDebt(d.id),
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 20)),
                                      child: const Text('Mark Settled', style: TextStyle(fontSize: 11, color: AppTheme.income, fontWeight: FontWeight.bold)),
                                    )
                                  else
                                    const Text('Settled', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
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
    ),
  ),
);
  }
}
