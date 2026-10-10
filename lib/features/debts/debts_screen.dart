import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
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
          backgroundColor: AppTheme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Catat Hutang / Piutang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'receivable'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: type == 'receivable' ? AppTheme.income.withValues(alpha: 0.2) : AppTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: type == 'receivable' ? AppTheme.income : AppTheme.border),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Piutang (Dipinjam)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'payable'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: type == 'payable' ? AppTheme.expense.withValues(alpha: 0.2) : AppTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: type == 'payable' ? AppTheme.expense : AppTheme.border),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Hutang (Meminjam)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Nama Pihak / Teman', filled: true, fillColor: AppTheme.surface),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Nominal (Rp)', filled: true, fillColor: AppTheme.surface),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Catatan', filled: true, fillColor: AppTheme.surface),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0.0;
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: const Text('Simpan Catatan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CATATAN PINJAMAN', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _openAddDebtDialog(context),
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: state.debts.isEmpty
                  ? const Center(child: Text('Belum ada catatan hutang/piutang.', style: TextStyle(fontSize: 12, color: AppTheme.subtle)))
                  : ListView.builder(
                      itemCount: state.debts.length,
                      itemBuilder: (_, idx) {
                        final d = state.debts[idx];
                        final isReceivable = d.type == 'receivable';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
                          ),
                          child: Row(
                            children: [
                              Icon(isReceivable ? Icons.call_made : Icons.call_received, color: isReceivable ? AppTheme.income : AppTheme.expense, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d.personName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text(isReceivable ? 'Piutang' : 'Hutang', style: TextStyle(fontSize: 10, color: isReceivable ? AppTheme.income : AppTheme.expense)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(d.amount, currency: state.currency),
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isReceivable ? AppTheme.income : AppTheme.expense),
                                  ),
                                  if (!d.isSettled)
                                    TextButton(
                                      onPressed: () => state.settleDebt(d.id),
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 20)),
                                      child: const Text('Tandai Lunas', style: TextStyle(fontSize: 10, color: AppTheme.income)),
                                    )
                                  else
                                    const Text('Lunas', style: TextStyle(fontSize: 10, color: AppTheme.subtle)),
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
