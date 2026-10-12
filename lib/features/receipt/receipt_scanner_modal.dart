import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/receipt_parser.dart';
import 'package:flow/core/services/voice_service.dart';
import 'package:flow/core/services/camera/camera_capture_service.dart';
import 'package:flow/models/receipt_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/receipt/receipt_viewfinder.dart';
import 'package:flow/features/receipt/receipt_action_buttons.dart';
import 'package:flow/features/receipt/receipt_ocr_text_box.dart';
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
  final TextEditingController _ocrTextController = TextEditingController();
  bool _isScanning = false;
  Uint8List? _imageBytes;
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

  @override
  void dispose() {
    _ocrTextController.dispose();
    super.dispose();
  }

  void _onCapture(bool fromCamera) async {
    setState(() => _isScanning = true);
    final result = fromCamera
        ? await CameraCaptureService.instance.captureFromCamera()
        : await CameraCaptureService.instance.pickFromGallery();

    if (result == null) {
      setState(() => _isScanning = false);
      return;
    }

    setState(() {
      _imageBytes = result.bytes;
      _isScanning = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    // OCR simulation from captured receipt
    final sampleText = '''INDOMARET POINT
2 x ROTI TAWAR 16.000
1 x SUSU ULTRA MILK 1L 21.500
1 x AIR MINERAL 5.000
TOTAL 42.500''';

    _ocrTextController.text = sampleText;
    _processReceiptText(sampleText);
  }

  void _processReceiptText(String raw) {
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
    final itemNotes = receipt.items.map((i) => '${i.quantity}x ${i.name}').join(', ');

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final sheetRadius = AppTheme.verticalTop(isDark, 24);

    return ClipRRect(
      borderRadius: sheetRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottomInset),
          decoration: AppTheme.liquidGlassDecoration(
            isDark: isDark,
            borderRadius: sheetRadius,
            elevated: true,
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
                  'Deteksi Struk Belanja (Kamera & OCR)',
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
            ReceiptViewfinder(
              isScanning: _isScanning,
              imageBytes: _imageBytes,
              onRetake: () => setState(() => _imageBytes = null),
            ),
            const SizedBox(height: 12),
            ReceiptActionButtons(
              onTapCamera: () => _onCapture(true),
              onTapGallery: () => _onCapture(false),
              isDark: isDark,
              isScanning: _isScanning,
            ),
            const SizedBox(height: 12),
            ReceiptOcrTextBox(
              controller: _ocrTextController,
              onChanged: _processReceiptText,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            ReceiptPresetPicker(
              isDark: isDark,
              onSelectPreset: (text) {
                _ocrTextController.text = text;
                _processReceiptText(text);
              },
            ),
            if (_parsedReceipt != null && _parsedReceipt!.isValid) ...[
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
    ),
    ),
    );
  }
}
