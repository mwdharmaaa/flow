import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/models/account_model.dart';

class AddAccountDialog extends StatefulWidget {
  final Function(AccountModel) onSave;

  const AddAccountDialog({super.key, required this.onSave});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _type = 'bank';
  int _colorValue = 0xFF1D61E0;

  final List<int> _colors = const [
    0xFF1D61E0,
    0xFF10B981,
    0xFF8B5CF6,
    0xFFF59E0B,
    0xFFF43F5E,
    0xFF06B6D4,
  ];

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final balance = double.tryParse(_balanceController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    final acc = AccountModel(
      id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: _type,
      balance: balance,
      colorValue: _colorValue,
    );

    widget.onSave(acc);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('New Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                IconButton(icon: const Icon(Icons.close, size: 20, color: AppTheme.subtle), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: _inputDecoration('Wallet Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _type,
              dropdownColor: Colors.white,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
              decoration: _inputDecoration('Account Type'),
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'bank', child: Text('Bank Account')),
                DropdownMenuItem(value: 'ewallet', child: Text('E-Wallet (GoPay, OVO, etc.)')),
                DropdownMenuItem(value: 'investment', child: Text('Savings / Investment')),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: _inputDecoration('Initial Balance (Rp)'),
            ),
            const SizedBox(height: 14),
            const Text('Color Accent', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _colors.map((c) {
                final isSelected = _colorValue == c;
                return GestureDetector(
                  onTap: () => setState(() => _colorValue = c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: AppTheme.textPrimary, width: 2) : null,
                    ),
                  ),
                );
              }).toList(),
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
              child: const Text('Save Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.subtle, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFF6F9FD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
    );
  }
}
