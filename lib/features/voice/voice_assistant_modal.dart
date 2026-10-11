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
  ParsedTransactionResult? _parsedResult;
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
        if (isFinal) {
          _processTranscript(text);
          setState(() => _isListening = false);
        }
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
    final result = NlpTransactionParser.parse(text);
    setState(() {
      _isListening = false;
      _transcriptController.text = text;
      _parsedResult = result;
    });
  }

  void _saveTransaction() {
    if (_parsedResult == null || !_parsedResult!.isValid) return;

    final res = _parsedResult!;
    final defaultAccountId = widget.state.accounts.isNotEmpty
        ? widget.state.accounts.first.id
        : 'acc_cash';

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: res.type,
      amount: res.amount,
      accountId: defaultAccountId,
      category: res.category,
      date: DateTime.now(),
      note: res.title,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    widget.state.addTransaction(tx);

    if (_speakResponse) {
      final feedback = VoiceService.instance.formatTransactionFeedback(
        title: res.title,
        amount: res.amount,
        category: res.category,
      );
      VoiceService.instance.speak(feedback);
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tercatat: ${res.title} ${CurrencyFormatter.format(res.amount, currency: widget.state.currency)}'),
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
            if (_parsedResult != null && _parsedResult!.isValid) ...[
              const SizedBox(height: 16),
              _buildResultCard(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(bool isDark) {
    final res = _parsedResult!;
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
                res.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.format(res.amount, currency: widget.state.currency),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
            onPressed: _saveTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Simpan Transaksi Suara',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
