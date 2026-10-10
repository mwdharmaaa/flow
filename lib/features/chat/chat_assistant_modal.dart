import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_message.dart';
import 'package:flow/features/chat/chat_message_bubble.dart';

class ChatAssistantModal extends StatefulWidget {
  final AppState state;
  final String? initialText;

  const ChatAssistantModal({
    super.key,
    required this.state,
    this.initialText,
  });

  static Future<void> show(BuildContext context, AppState state, {String? initialText}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChatAssistantModal(state: state, initialText: initialText),
    );
  }

  @override
  State<ChatAssistantModal> createState() => _ChatAssistantModalState();
}

class _ChatAssistantModalState extends State<ChatAssistantModal> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  final List<String> _suggestions = const [
    'coffee 18k',
    'lunch 25k',
    'bensin 20k',
    'gaji 5jt',
    'listrik 150k',
    'shopee 80k',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: 'Hi! Ketik transaksi dengan format natural, contoh "coffee 18k", "bensin 20k", atau "gaji 5jt".',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    if (widget.initialText != null && widget.initialText!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSend(widget.initialText!.trim());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String input) {
    final text = input.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    });
    _scrollToBottom();

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

      final typeLabel = result.type == TransactionType.income ? 'Pemasukan' : 'Pengeluaran';
      final formattedAmount = CurrencyFormatter.format(result.amount, currency: widget.state.currency);

      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Tercatat: $typeLabel "${result.title}" sebesar $formattedAmount (${result.category}) berhasil disimpan.',
            isUser: false,
            timestamp: DateTime.now(),
            parsedResult: result,
          ),
        );
      });
    } else {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Format belum dikenali. Coba sertakan nama transaksi dan nominal, misalnya "kopi 18k" atau "bensin 20rb".',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = widget.state.isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(isDark),
          _buildSuggestions(isDark),
          Expanded(child: _buildMessagesList()),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final borderCol = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;
    final textCol = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final subtleCol = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final activeColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderCol)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flow Assistant',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textCol),
                  ),
                  Text(
                    'Ketik pengeluaran atau pemasukan',
                    style: TextStyle(fontSize: 11, color: subtleCol),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.close, color: subtleCol, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(bool isDark) {
    final chipBg = isDark ? AppTheme.darkAccentSubtle : AppTheme.primarySoft;
    final activeColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final s = _suggestions[index];
          return ActionChip(
            label: Text(s, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: activeColor)),
            backgroundColor: chipBg,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () => _handleSend(s),
          );
        },
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) => ChatMessageBubble(message: _messages[index]),
    );
  }

  Widget _buildInputBar(bool isDark) {
    final borderCol = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;
    final bg = isDark ? AppTheme.darkBgSurface : Colors.white;
    final inputBg = isDark ? AppTheme.darkBgElevated : const Color(0xFFF6F8FB);
    final textCol = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final subtleCol = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final activeColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: borderCol)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderCol),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _handleSend,
                  style: TextStyle(fontSize: 13, color: textCol),
                  decoration: InputDecoration(
                    hintText: 'Ketik contoh: kopi 18k...',
                    hintStyle: TextStyle(fontSize: 12, color: subtleCol),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _handleSend(_controller.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
