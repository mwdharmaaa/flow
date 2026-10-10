class AccountModel {
  final String id;
  final String name;
  final String type;
  final double balance;
  final int colorValue;
  final bool isExcludedFromTotal;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.colorValue,
    this.isExcludedFromTotal = false,
  });

  AccountModel copyWith({
    String? id,
    String? name,
    String? type,
    double? balance,
    int? colorValue,
    bool? isExcludedFromTotal,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      colorValue: colorValue ?? this.colorValue,
      isExcludedFromTotal: isExcludedFromTotal ?? this.isExcludedFromTotal,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'balance': balance,
        'colorValue': colorValue,
        'isExcludedFromTotal': isExcludedFromTotal,
      };

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        balance: (json['balance'] as num).toDouble(),
        colorValue: json['colorValue'] as int? ?? 0xFF3B82F6,
        isExcludedFromTotal: json['isExcludedFromTotal'] as bool? ?? false,
      );
}
