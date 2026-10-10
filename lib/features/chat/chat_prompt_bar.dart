import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_assistant_modal.dart';

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

    final result = NlpTransactionParser.parse(text);
    if (result.isValid) {
      final defaultAccountId = widget.state.accounts.isNotEmpty
          ? widget.state.accounts.first.id
          : 'acc_cash';

      final newTx = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: result.type,
        amount: result.amount,
        accountId: defaultAccountId,
        category: result.category,
        date: DateTime.now(),
        note: result.title,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      widget.state.addTransaction(newTx);
      _controller.clear();
      FocusScope.of(context).unfocus();

      final formatted = CurrencyFormatter.format(result.amount, currency: widget.state.currency);
      final typeLabel = result.type == TransactionType.income ? 'Pemasukan' : 'Pengeluaran';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tercatat: $typeLabel "${result.title}" $formatted (${result.category})'),
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
    final isDark = widget.state.isDarkMode;
    final activeColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;
    final textCol = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final subtleCol = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final borderCol = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;
    final bg = isDark ? AppTheme.darkBgElevated : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderCol),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chat_bubble_outline_rounded, size: 18, color: activeColor),
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
              style: TextStyle(fontSize: 13, color: textCol),
              decoration: InputDecoration(
                hintText: 'Try typing "coffee 18k" in chat',
                hintStyle: TextStyle(fontSize: 12, color: subtleCol),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (_hasText)
            IconButton(
              icon: Icon(Icons.arrow_upward_rounded, size: 18, color: activeColor),
              onPressed: () => _handleSubmit(_controller.text),
              splashRadius: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            )
          else
            IconButton(
              icon: Icon(Icons.chevron_right, size: 20, color: subtleCol),
              onPressed: () => _openChatModal(),
              splashRadius: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}
