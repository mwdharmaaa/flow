import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_assistant_modal.dart';
import 'package:flow/features/voice/voice_assistant_modal.dart';

class ChatPromptBar extends StatefulWidget {
  final AppState state;

  const ChatPromptBar({super.key, required this.state});

  @override
  State<ChatPromptBar> createState() => _ChatPromptBarState();
}

class _ChatPromptBarState extends State<ChatPromptBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) {
        setState(() => _hasText = has);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openChatModal([String? text]) {
    ChatAssistantModal.show(context, widget.state, initialText: text);
  }

  void _handleSubmit(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      _openChatModal();
      return;
    }

    final results = NlpTransactionParser.parseAll(text);
    if (results.isNotEmpty) {
      final defaultAccountId = widget.state.accounts.isNotEmpty
          ? widget.state.accounts.first.id
          : 'acc_cash';

      final now = DateTime.now();
      for (var i = 0; i < results.length; i++) {
        final result = results[i];
        final newTx = TransactionModel(
          id: '${now.millisecondsSinceEpoch}_$i',
          type: result.type,
          amount: result.amount,
          accountId: defaultAccountId,
          category: result.category,
          date: now,
          note: result.title,
          createdAt: now.millisecondsSinceEpoch + i,
        );
        widget.state.addTransaction(newTx);
      }

      _controller.clear();
      FocusScope.of(context).unfocus();

      final total = results.fold<double>(0.0, (sum, i) => sum + i.amount);
      final formattedTotal = CurrencyFormatter.format(total, currency: widget.state.currency);
      final msg = results.length == 1
          ? 'Tercatat: ${results.first.type == TransactionType.income ? "Pemasukan" : "Pengeluaran"} "${results.first.title}" ${CurrencyFormatter.format(results.first.amount, currency: widget.state.currency)} (${results.first.category})'
          : 'Tercatat ${results.length} transaksi ($formattedTotal)';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      _controller.clear();
      _openChatModal(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppTheme.primary),
            onPressed: () => _openChatModal(_controller.text),
            tooltip: 'Open Chat Assistant',
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: _handleSubmit,
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Try typing "coffee 18k" in chat',
                hintStyle: TextStyle(fontSize: 12, color: AppTheme.subtle),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (_hasText)
            IconButton(
              icon: const Icon(Icons.arrow_upward_rounded, size: 18, color: AppTheme.primary),
              onPressed: () => _handleSubmit(_controller.text),
              splashRadius: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.mic_none_rounded, size: 18, color: AppTheme.primary),
                  onPressed: () => VoiceAssistantModal.show(context, widget.state),
                  tooltip: 'Voice Input',
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20, color: AppTheme.subtle),
                  onPressed: () => _openChatModal(),
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 30),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
