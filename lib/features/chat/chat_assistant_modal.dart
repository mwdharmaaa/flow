import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/parsers/nlp_transaction_parser.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_message.dart';
import 'package:flow/features/chat/chat_message_bubble.dart';
import 'package:flow/core/services/voice_service.dart';
import 'package:flow/features/voice/voice_assistant_modal.dart';
import 'package:flow/features/receipt/receipt_scanner_modal.dart';

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
  bool _isVoiceOutputEnabled = true;

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

      if (_isVoiceOutputEnabled) {
        final speech = VoiceService.instance.formatTransactionFeedback(
          title: result.title,
          amount: result.amount,
          category: result.category,
        );
        VoiceService.instance.speak(speech);
      }
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSuggestions(),
          Expanded(child: _buildMessagesList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flow Assistant',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  Text(
                    'Ketik pengeluaran atau pemasukan',
                    style: TextStyle(fontSize: 11, color: AppTheme.subtle),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isVoiceOutputEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: _isVoiceOutputEnabled ? AppTheme.primary : AppTheme.subtle,
                  size: 20,
                ),
                tooltip: _isVoiceOutputEnabled ? 'Voice Output Aktif' : 'Voice Output Mati',
                onPressed: () => setState(() => _isVoiceOutputEnabled = !_isVoiceOutputEnabled),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.subtle, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
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
            label: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)),
            backgroundColor: AppTheme.primarySoft,
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

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FB),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _handleSend,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Ketik contoh: kopi 18k...',
                    hintStyle: TextStyle(fontSize: 12, color: AppTheme.subtle),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.mic_none_rounded, color: AppTheme.primary, size: 22),
              tooltip: 'Voice Input',
              onPressed: () {
                Navigator.of(context).pop();
                VoiceAssistantModal.show(context, widget.state);
              },
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long_outlined, color: AppTheme.primary, size: 20),
              tooltip: 'Pindai Struk',
              onPressed: () {
                Navigator.of(context).pop();
                ReceiptScannerModal.show(context, widget.state);
              },
            ),
            GestureDetector(
              onTap: () => _handleSend(_controller.text),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
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
