import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/account_model.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryItem(this.name, this.icon, this.color);
}

const List<CategoryItem> kDefaultCategories = [
  CategoryItem('Food', Icons.restaurant, Color(0xFFF43F5E)),
  CategoryItem('Shopping', Icons.shopping_bag, Color(0xFFEC4899)),
  CategoryItem('Transport', Icons.directions_car, Color(0xFF3B82F6)),
  CategoryItem('Bills', Icons.receipt, Color(0xFFEAB308)),
  CategoryItem('Entertainment', Icons.movie, Color(0xFF8B5CF6)),
  CategoryItem('Health', Icons.local_hospital, Color(0xFF10B981)),
  CategoryItem('Education', Icons.school, Color(0xFF06B6D4)),
  CategoryItem('Salary', Icons.payments, Color(0xFF10B981)),
  CategoryItem('Investment', Icons.trending_up, Color(0xFF6366F1)),
  CategoryItem('Other', Icons.more_horiz, Color(0xFF64748B)),
];

class AddTransactionDialog extends StatefulWidget {
  final List<AccountModel> accounts;
  final TransactionType initialType;
  final Function(TransactionModel) onSave;

  const AddTransactionDialog({
    super.key,
    required this.accounts,
    this.initialType = TransactionType.expense,
    required this.onSave,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  late TransactionType _type;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late String _selectedAccountId;
  late String _selectedDestAccountId;
  String _selectedCategory = kDefaultCategories.first.name;
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _selectedAccountId = widget.accounts.isNotEmpty ? widget.accounts.first.id : '';
    _selectedDestAccountId = widget.accounts.length > 1 ? widget.accounts[1].id : _selectedAccountId;
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (amount == null || amount <= 0 || _selectedAccountId.isEmpty) return;

    final tx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: _type,
      amount: amount,
      accountId: _selectedAccountId,
      destinationAccountId: _type == TransactionType.transfer ? _selectedDestAccountId : null,
      category: _type == TransactionType.transfer ? 'Transfer' : _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    widget.onSave(tx);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Log Transaction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppTheme.subtle),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildTypeTab(TransactionType.expense, 'Expense', AppTheme.expense),
                  const SizedBox(width: 8),
                  _buildTypeTab(TransactionType.income, 'Income', AppTheme.income),
                  const SizedBox(width: 8),
                  _buildTypeTab(TransactionType.transfer, 'Transfer', AppTheme.transfer),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(
                    color: AppTheme.subtle,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: '0',
                  hintStyle: const TextStyle(color: Color(0xFFA3B8D8)),
                  filled: true,
                  fillColor: const Color(0xFFF6F9FD),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                ),
              ),
              if (_type != TransactionType.transfer) ...[
                const SizedBox(height: 16),
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.subtle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: kDefaultCategories.length,
                    itemBuilder: (_, idx) {
                      final cat = kDefaultCategories[idx];
                      final isSelected = _selectedCategory == cat.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat.name),
                        child: Container(
                          width: 65,
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: cat.color.withValues(alpha: isSelected ? 0.2 : 0.08),
                                  shape: BoxShape.circle,
                                  border: isSelected ? Border.all(color: cat.color, width: 2) : null,
                                ),
                                child: Icon(cat.icon, size: 20, color: cat.color),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? AppTheme.textPrimary : AppTheme.subtle,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedAccountId,
                dropdownColor: Colors.white,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: _inputDecoration(_type == TransactionType.transfer ? 'From Wallet' : 'Wallet', Icons.account_balance_wallet_outlined),
                items: widget.accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (val) => setState(() => _selectedAccountId = val!),
              ),
              if (_type == TransactionType.transfer) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedDestAccountId,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                  decoration: _inputDecoration('To Destination Wallet', Icons.move_to_inbox_outlined),
                  items: widget.accounts.where((a) => a.id != _selectedAccountId).map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                  onChanged: (val) => setState(() => _selectedDestAccountId = val!),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: _inputDecoration('Note (Optional)', Icons.notes_outlined),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Transaction', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeTab(TransactionType type, String label, Color color) {
    final isSelected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFFF6F9FD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : AppTheme.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : AppTheme.subtle,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.subtle, fontSize: 12),
      prefixIcon: Icon(icon, size: 18, color: AppTheme.subtle),
      filled: true,
      fillColor: const Color(0xFFF6F9FD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primary)),
    );
  }
}
