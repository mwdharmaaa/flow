import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/models/budget_model.dart';

class AddBudgetDialog extends StatefulWidget {
  final Function(BudgetModel) onSave;

  const AddBudgetDialog({super.key, required this.onSave});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _limitController = TextEditingController();
  String _category = 'Makanan & Minuman';
  final int _colorValue = 0xFFF43F5E;

  final List<String> _categories = const [
    'Makanan & Minuman',
    'Transportasi',
    'Belanja',
    'Hiburan & Langganan',
    'Tagihan & Utilitas',
    'Kesehatan',
    'Pendidikan',
    'Lain-lain',
  ];

  void _submit() {
    final limit = double.tryParse(_limitController.text) ?? 0.0;
    if (limit <= 0) return;

    final bgt = BudgetModel(
      id: 'bgt_${DateTime.now().millisecondsSinceEpoch}',
      category: _category,
      monthlyLimit: limit,
      spent: 0,
      colorValue: _colorValue,
    );

    widget.onSave(bgt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tambah Batas Anggaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(icon: const Icon(Icons.close, size: 20, color: AppTheme.subtle), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              dropdownColor: AppTheme.card,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: _inputDecoration('Pilih Kategori'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Batas Bulanan (Rp)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Simpan Anggaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      fillColor: AppTheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
    );
  }
}
