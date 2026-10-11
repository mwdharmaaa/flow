class ReceiptItem {
  final String name;
  final int quantity;
  final double price;

  const ReceiptItem({
    required this.name,
    this.quantity = 1,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => ReceiptItem(
    name: json['name'] as String? ?? 'Item',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
  );
}

class ReceiptData {
  final String merchant;
  final DateTime date;
  final List<ReceiptItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String suggestedCategory;
  final String rawText;

  const ReceiptData({
    required this.merchant,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.suggestedCategory,
    required this.rawText,
  });

  bool get isValid => total > 0 || items.isNotEmpty;
}
