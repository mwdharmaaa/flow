import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/transactions/transaction_card.dart';
import 'package:flow/features/transactions/add_transaction_dialog.dart';
import 'package:flow/models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  final AppState state;

  const TransactionsScreen({super.key, required this.state});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.transactions.where((tx) {
      final matchesSearch = tx.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.note.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _filterType == 'all' || tx.type.name == _filterType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Cari transaksi...',
                      hintStyle: const TextStyle(color: AppTheme.subtle, fontSize: 12),
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.subtle),
                      filled: true,
                      fillColor: AppTheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddTransactionDialog(
                        accounts: widget.state.accounts,
                        onSave: (tx) => widget.state.addTransaction(tx),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Baru', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('all', 'Semua'),
                  const SizedBox(width: 6),
                  _buildFilterTab('expense', 'Pengeluaran'),
                  const SizedBox(width: 6),
                  _buildFilterTab('income', 'Pemasukan'),
                  const SizedBox(width: 6),
                  _buildFilterTab('transfer', 'Transfer'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('Tidak ada transaksi ditemukan.', style: TextStyle(color: AppTheme.subtle, fontSize: 12)),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, idx) => TransactionCard(
                        transaction: filtered[idx],
                        accounts: widget.state.accounts,
                        currency: widget.state.currency,
                        onDelete: () => widget.state.deleteTransaction(filtered[idx].id),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String type, String label) {
    final isSelected = _filterType == type;
    return GestureDetector(
      onTap: () => setState(() => _filterType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.2) : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.primary : AppTheme.subtle,
          ),
        ),
      ),
    );
  }
}
