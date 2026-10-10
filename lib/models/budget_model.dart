class BudgetModel {
  final String id;
  final String category;
  final double monthlyLimit;
  final double spent;
  final int colorValue;

  BudgetModel({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.spent,
    required this.colorValue,
  });

  BudgetModel copyWith({
    String? id,
    String? category,
    double? monthlyLimit,
    double? spent,
    int? colorValue,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      spent: spent ?? this.spent,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'monthlyLimit': monthlyLimit,
        'spent': spent,
        'colorValue': colorValue,
      };

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        id: json['id'] as String,
        category: json['category'] as String,
        monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
        spent: (json['spent'] as num).toDouble(),
        colorValue: json['colorValue'] as int? ?? 0xFFF43F5E,
      );
}
