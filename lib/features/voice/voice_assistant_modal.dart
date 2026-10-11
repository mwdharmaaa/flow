import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/services/voice_service.dart';
import 'package:flow/core/services/speech/speech_recognition_service.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/voice/voice_waveform_visualizer.dart';
import 'package:flow/features/voice/voice_preset_chips.dart';

class VoiceAssistantModal extends StatefulWidget {
  final AppState state;

  const VoiceAssistantModal({super.key, required this.state});

  static Future<void> show(BuildContext context, AppState state) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VoiceAssistantModal(state: state),
    );
  }

  @override
  State<VoiceAssistantModal> createState() => _VoiceAssistantModalState();
}

class _VoiceAssistantModalState extends State<VoiceAssistantModal> {
  final TextEditingController _transcriptController = TextEditingController();
  bool _isListening = false;
  List<ParsedTransactionResult> _parsedResults = [];
  bool _speakResponse = true;

  @override
  void dispose() {
    SpeechRecognitionService.instance.stopListening();
    _transcriptController.dispose();
    super.dispose();
  }

  void _toggleListening([String? presetVoice]) {
    if (presetVoice != null) {
      SpeechRecognitionService.instance.stopListening();
      setState(() {
        _isListening = false;
        _transcriptController.text = presetVoice;
      });
      _processTranscript(presetVoice);
      return;
    }

    if (_isListening) {
      SpeechRecognitionService.instance.stopListening();
      setState(() => _isListening = false);
      if (_transcriptController.text.isNotEmpty &&
          !_transcriptController.text.startsWith('Mendengarkan')) {
        _processTranscript(_transcriptController.text);
      }
      return;
    }

    setState(() {
      _isListening = true;
      _transcriptController.text = 'Mendengarkan... Silakan bicara';
    });

    SpeechRecognitionService.instance.startListening(
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() {
          _transcriptController.text = text;
        });
        _processTranscript(text);
      },
      onError: (err) {
        if (!mounted) return;
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            backgroundColor: AppTheme.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onDone: () {
        if (!mounted) return;
        if (_isListening) {
          setState(() => _isListening = false);
          if (_transcriptController.text.isNotEmpty &&
              !_transcriptController.text.startsWith('Mendengarkan')) {
            _processTranscript(_transcriptController.text);
          }
        }
      },
    );
  }

  void _processTranscript(String text) {
    final results = NlpTransactionParser.parseAll(text);
    setState(() {
      _parsedResults = results;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _parsedResults.removeAt(index);
    });
  }

  void _saveTransactions() {
    if (_parsedResults.isEmpty) return;

    final defaultAccountId = widget.state.accounts.isNotEmpty
        ? widget.state.accounts.first.id
        : 'acc_cash';

    final now = DateTime.now();
    for (var i = 0; i < _parsedResults.length; i++) {
      final res = _parsedResults[i];
      final tx = TransactionModel(
        id: '${now.millisecondsSinceEpoch}_$i',
        type: res.type,
        amount: res.amount,
        accountId: defaultAccountId,
        category: res.category,
        date: now,
        note: res.title,
        createdAt: now.millisecondsSinceEpoch + i,
      );
      widget.state.addTransaction(tx);
    }

    if (_speakResponse) {
      final feedback = VoiceService.instance.formatMultipleTransactionsFeedback(_parsedResults);
      VoiceService.instance.speak(feedback);
    }

    Navigator.of(context).pop();

    final total = _parsedResults.fold<double>(0.0, (sum, i) => sum + i.amount);
    final summaryText = _parsedResults.length == 1
        ? 'Tercatat: ${_parsedResults.first.title} ${CurrencyFormatter.format(_parsedResults.first.amount, currency: widget.state.currency)}'
        : 'Tercatat ${_parsedResults.length} transaksi (${CurrencyFormatter.format(total, currency: widget.state.currency)})';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(summaryText),
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
                  'Pencatat Suara (Voice Input & Output)',
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
            const SizedBox(height: 12),
            VoiceWaveformVisualizer(isListening: _isListening),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => _toggleListening(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _isListening ? AppTheme.expense : AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? AppTheme.expense : AppTheme.primary)
                            .withValues(alpha: 0.35),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _transcriptController,
              textAlign: TextAlign.center,
              onChanged: _processTranscript,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Ketuk mikrofon atau sebutkan transaksi',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                ),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 12),
            VoicePresetChips(
              isDark: isDark,
              onSelect: (val) => _toggleListening(val),
            ),
            if (_parsedResults.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResultCard(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(bool isDark) {
    final totalAmount = _parsedResults.fold<double>(0.0, (sum, item) => sum + item.amount);
    final isMultiple = _parsedResults.length > 1;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isMultiple
                    ? 'Terdeteksi ${_parsedResults.length} Transaksi'
                    : 'Terdeteksi Transaksi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                ),
              ),
              Text(
                'Total: ${CurrencyFormatter.format(totalAmount, currency: widget.state.currency)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _parsedResults.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = _parsedResults[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBgBase : AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      CurrencyFormatter.format(item.amount, currency: widget.state.currency),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: item.type == TransactionType.income
                            ? AppTheme.income
                            : AppTheme.expense,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      tooltip: 'Hapus item',
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                      onPressed: () => _removeItem(index),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suarakan Jawaban (Voice Output)',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                ),
              ),
              Switch.adaptive(
                value: _speakResponse,
                onChanged: (v) => setState(() => _speakResponse = v),
                activeColor: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _saveTransactions,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isMultiple
                  ? 'Simpan ${_parsedResults.length} Transaksi Suara'
                  : 'Simpan Transaksi Suara',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
