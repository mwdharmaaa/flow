import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/account_model.dart';

class AdjustBalanceDialog extends StatefulWidget {
  final AccountModel account;
  final String currency;
  final Function(double) onSave;

  const AdjustBalanceDialog({
    super.key,
    required this.account,
    required this.currency,
    required this.onSave,
  });

  @override
  State<AdjustBalanceDialog> createState() => _AdjustBalanceDialogState();
}

class _AdjustBalanceDialogState extends State<AdjustBalanceDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.account.balance == 0
        ? '0'
        : widget.account.balance.toStringAsFixed(0);
  }

  void _submit() {
    final val = double.tryParse(_controller.text.replaceAll(RegExp(r'[^0-9.-]'), ''));
    if (val == null) return;
    widget.onSave(val);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                Text(
                  'Sesuaikan Saldo',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppTheme.subtle),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.account.name} (Saldo saat ini: ${CurrencyFormatter.format(widget.account.balance, currency: widget.currency)})',
              style: const TextStyle(fontSize: 12, color: AppTheme.subtle),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Saldo Baru Sebenarnya',
                labelStyle: const TextStyle(color: AppTheme.subtle),
                filled: true,
                fillColor: AppTheme.surface,
                prefixText: '${widget.currency} ',
                prefixStyle: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Perbarui Saldo',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
