import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/receipt_parser.dart';
import 'package:flow/core/services/voice_service.dart';
import 'package:flow/models/receipt_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/receipt/receipt_viewfinder.dart';
import 'package:flow/features/receipt/receipt_preset_picker.dart';
import 'package:flow/features/receipt/receipt_result_card.dart';

class ReceiptScannerModal extends StatefulWidget {
  final AppState state;

  const ReceiptScannerModal({super.key, required this.state});

  static Future<void> show(BuildContext context, AppState state) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReceiptScannerModal(state: state),
    );
  }

  @override
  State<ReceiptScannerModal> createState() => _ReceiptScannerModalState();
}

class _ReceiptScannerModalState extends State<ReceiptScannerModal> {
  bool _isScanning = false;
  ReceiptData? _parsedReceipt;
  late String _selectedAccountId;
  late String _selectedCategory;
  bool _speakOnSave = true;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.state.accounts.isNotEmpty
        ? widget.state.accounts.first.id
        : 'acc_cash';
    _selectedCategory = 'Shopping';
  }

  void _processReceiptText(String raw) async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final parsed = ReceiptParser.parse(raw);
    setState(() {
      _isScanning = false;
      _parsedReceipt = parsed;
      _selectedCategory = parsed.suggestedCategory;
    });
  }

  void _handleSave() {
    if (_parsedReceipt == null || !_parsedReceipt!.isValid) return;

    final receipt = _parsedReceipt!;
    final itemNotes = receipt.items
        .map((i) => '${i.quantity}x ${i.name}')
        .join(', ');

    final newTx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TransactionType.expense,
      amount: receipt.total,
      accountId: _selectedAccountId,
      category: _selectedCategory,
      date: DateTime.now(),
      note: '${receipt.merchant}: $itemNotes',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    widget.state.addTransaction(newTx);

    if (_speakOnSave) {
      final voiceText = VoiceService.instance.formatReceiptFeedback(
        merchant: receipt.merchant,
        total: receipt.total,
        itemCount: receipt.items.length,
      );
      VoiceService.instance.speak(voiceText);
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Struk ${receipt.merchant} berhasil disimpan!'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottomInset),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgBase : AppTheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deteksi Struk Belanja (OCR)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ReceiptViewfinder(isScanning: _isScanning),
            const SizedBox(height: 14),
            ReceiptPresetPicker(
              isDark: isDark,
              onSelectPreset: _processReceiptText,
            ),
            if (_parsedReceipt != null) ...[
              const SizedBox(height: 14),
              ReceiptResultCard(
                receipt: _parsedReceipt!,
                currency: widget.state.currency,
                accounts: widget.state.accounts,
                selectedAccountId: _selectedAccountId,
                selectedCategory: _selectedCategory,
                speakOnSave: _speakOnSave,
                onAccountChanged: (id) => setState(() => _selectedAccountId = id),
                onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
                onSpeakToggle: (val) => setState(() => _speakOnSave = val),
                onSave: _handleSave,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
