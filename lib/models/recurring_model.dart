class RecurringModel {
  final String id;
  final String name;
  final String type; // 'expense' or 'income'
  final double amount;
  final String accountId;
  final String category;
  final String interval; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime nextDate;
  final bool isActive;

  RecurringModel({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.accountId,
    required this.category,
    required this.interval,
    required this.nextDate,
    this.isActive = true,
  });

  RecurringModel copyWith({
    String? id,
    String? name,
    String? type,
    double? amount,
    String? accountId,
    String? category,
    String? interval,
    DateTime? nextDate,
    bool? isActive,
  }) {
    return RecurringModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      category: category ?? this.category,
      interval: interval ?? this.interval,
      nextDate: nextDate ?? this.nextDate,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'amount': amount,
        'accountId': accountId,
        'category': category,
        'interval': interval,
        'nextDate': nextDate.toIso8601String(),
        'isActive': isActive,
      };

  factory RecurringModel.fromJson(Map<String, dynamic> json) => RecurringModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        amount: (json['amount'] as num).toDouble(),
        accountId: json['accountId'] as String,
        category: json['category'] as String,
        interval: json['interval'] as String,
        nextDate: DateTime.parse(json['nextDate'] as String),
        isActive: json['isActive'] as bool? ?? true,
      );
}
