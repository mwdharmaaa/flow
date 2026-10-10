import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/models/goal_model.dart';

class AddGoalDialog extends StatefulWidget {
  final Function(GoalModel) onSave;

  const AddGoalDialog({super.key, required this.onSave});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final DateTime _targetDate = DateTime.now().add(const Duration(days: 90));

  void _submit() {
    final name = _nameController.text.trim();
    final target = double.tryParse(_targetController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (name.isEmpty || target == null || target <= 0) return;

    final goal = GoalModel(
      id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      targetAmount: target,
      savedAmount: 0.0,
      targetDate: _targetDate,
      colorValue: 0xFF1D61E0,
    );

    widget.onSave(goal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                const Text(
                  'New Savings Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppTheme.subtle),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Goal Name (e.g. Emergency Fund, Trip)',
                labelStyle: const TextStyle(color: AppTheme.subtle, fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF6F9FD),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Target Amount',
                labelStyle: const TextStyle(color: AppTheme.subtle, fontSize: 13),
                prefixText: 'Rp ',
                prefixStyle: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: const Color(0xFFF6F9FD),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
              ),
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
              child: const Text('Save Goal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
