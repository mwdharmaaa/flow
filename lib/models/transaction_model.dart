enum TransactionType { expense, income, transfer }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String accountId;
  final String? destinationAccountId;
  final String category;
  final DateTime date;
  final String note;
  final int createdAt;
  final bool excludeFromTotals;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.accountId,
    this.destinationAccountId,
    required this.category,
    required this.date,
    required this.note,
    required this.createdAt,
    this.excludeFromTotals = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'accountId': accountId,
        'destinationAccountId': destinationAccountId,
        'category': category,
        'date': date.toIso8601String(),
        'note': note,
        'createdAt': createdAt,
        'excludeFromTotals': excludeFromTotals,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        amount: (json['amount'] as num).toDouble(),
        accountId: json['accountId'] as String,
        destinationAccountId: json['destinationAccountId'] as String?,
        category: json['category'] as String,
        date: DateTime.parse(json['date'] as String),
        note: json['note'] as String? ?? '',
        createdAt: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        excludeFromTotals: json['excludeFromTotals'] as bool? ?? false,
      );
}
