class DebtModel {
  final String id;
  final String type; // 'receivable' or 'payable'
  final String personName;
  final double amount;
  final double remainingAmount;
  final DateTime dueDate;
  final String note;
  final bool isSettled;

  DebtModel({
    required this.id,
    required this.type,
    required this.personName,
    required this.amount,
    required this.remainingAmount,
    required this.dueDate,
    required this.note,
    this.isSettled = false,
  });

  DebtModel copyWith({
    String? id,
    String? type,
    String? personName,
    double? amount,
    double? remainingAmount,
    DateTime? dueDate,
    String? note,
    bool? isSettled,
  }) {
    return DebtModel(
      id: id ?? this.id,
      type: type ?? this.type,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      isSettled: isSettled ?? this.isSettled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'personName': personName,
        'amount': amount,
        'remainingAmount': remainingAmount,
        'dueDate': dueDate.toIso8601String(),
        'note': note,
        'isSettled': isSettled,
      };

  factory DebtModel.fromJson(Map<String, dynamic> json) => DebtModel(
        id: json['id'] as String,
        type: json['type'] as String,
        personName: json['personName'] as String,
        amount: (json['amount'] as num).toDouble(),
        remainingAmount: (json['remainingAmount'] as num).toDouble(),
        dueDate: DateTime.parse(json['dueDate'] as String),
        note: json['note'] as String? ?? '',
        isSettled: json['isSettled'] as bool? ?? false,
      );
}
