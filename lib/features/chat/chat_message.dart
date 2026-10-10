import 'package:flow/core/parsers/nlp_transaction_parser.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final ParsedTransactionResult? parsedResult;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.parsedResult,
  });
}
